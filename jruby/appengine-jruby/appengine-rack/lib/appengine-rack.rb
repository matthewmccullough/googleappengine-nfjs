#!/usr/bin/ruby1.8 -w
#
# Copyright:: Copyright 2009 Google Inc.
# Original Author:: Ryan Brown (mailto:ribrdb@google.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

begin
  require 'appengine-apis/urlfetch'
rescue Exception
end

module AppEngine
  module Rack
    ROOT = File.expand_path(File.dirname(__FILE__))
    
    class Resources
      def initialize
        @includes = []
        @excludes = []
      end
    
      def include(glob)
        @includes << glob
      end
    
      def exclude(glob)
        @excludes << glob
      end
    
      def append_to(xml, type)
        resources = xml.add_element(type) 
        @includes.each do |path|
          resources.add_element('include').add_attribute('path', path)
        end
        @excludes.each do |path|
          resources.add_element('exclude').add_attribute('path', path)
        end
      end
    end
  
    class PropertyMap < Hash
      def append_to(xml)
        unless empty?
          sys = xml.add_element('system-properties') 
          each do |name, value|
            sys.add_element('property').
                add_attributes( { "name" => name, "value" => value } )
          end
        end
      end
    end
  
    class EnvVarMap < Hash
      def append_to(xml)
        unless empty?
          env = xml.add_element('env-variables') 
          each do |name, value|
            env.add_element('env-var').
                add_attributes( { "name" => name, "value" => value } )
          end
        end
      end    
    end
  
    class RackApplication
      attr_accessor :application, :public_root
      attr_reader :version, :static_files, :resource_files
      attr_reader :system_properties, :environment_variables
      attr_writer :ssl_enabled, :sessions_enabled
    
      def initialize
        @version = '1'
        @system_properties = PropertyMap[ 'os.arch' => '',
                         'jruby.management.enabled' => 'false' ]
        @environment_variables = EnvVarMap.new
        @static_files = Resources.new
        @resource_files = Resources.new
        @public_root = '/public'
      end
    
      alias id application
    
      def sessions_enabled?
        @sessions_enabled
      end
    
      def ssl_enabled?
        @ssl_enabled
      end
      
      def version=(version)
        @version = version.to_s
      end
    
      def configure(options={})
        [:system_properties, :environment_variables].each do |key|
          self.send(key).merge!(options.delete(key)) if options[key]
        end
        options.each { |k,v| self.send("#{k}=", v) }
      end
    
      def to_xml
        require 'rexml/document'

        xml = REXML::Document.new.add_element('appengine-web-app')
        xml.add_attribute('xmlns','http://appengine.google.com/ns/1.0')
        xml.add_element('application').add_text(application)
        xml.add_element('version').add_text(version)
        xml.add_element('public-root').add_text(@public_root) if @public_root
        static_files.append_to(xml, 'static-files')
        resource_files.append_to(xml, 'resource-files')
        system_properties.append_to(xml)
        environment_variables.append_to(xml)
        if sessions_enabled?
          xml.add_element('sessions-enabled').add_text('true')
        end
        if ssl_enabled?
          xml.add_element('ssl-enabled').add_text('true')
        end
        return xml
      end
    end
    
    class SecurityMiddleware
      def self.append_xml(doc, pattern)
        security = doc.add_element('security-constraint')
        collection = security.add_element('web-resource-collection')
        collection.add_element('url-pattern').add_text(pattern)
        collection.add_element('url-pattern').add_text(
            AppEngine::Rack.make_wildcard(pattern))
        yield security
      end

      def self.new(app, *args, &block)
        app
      end      
      
    end
    
    class AdminRequired < SecurityMiddleware
      def self.append_xml(doc, pattern)
        super(doc, pattern) do |security|
          auth = security.add_element('auth-constraint')
          auth.add_element('role-name').add_text('admin')
        end
      end
    end
  
    class LoginRequired < SecurityMiddleware
      def self.append_xml(doc, pattern)
        super(doc, pattern) do |security|
          auth = security.add_element('auth-constraint')
          auth.add_element('role-name').add_text('*')
        end
      end
    end

    class SSLRequired < SecurityMiddleware
      def self.append_xml(doc, pattern)
        super(doc, pattern) do |security|
          udc = security.add_element('user-data-constraint')
          udc.add_element('transport-guarantee').add_text('CONFIDENTIAL')
        end
      end
    end  

    class << self
      def app
        @app ||= RackApplication.new
      end

      def configure_app(options={})
        @app = RackApplication.new
        @app.configure(options)
      end

      def environment
        if $servlet_context
          if $servlet_context.server_info =~ %r{^Google App Engine Development/}
            "development"
          elsif $servlet_context.server_info =~ %r{^Google App Engine/}
            "production"
          end
        end
      end
      
      
      def make_wildcard(pattern)
        "#{pattern}/*".squeeze('/')
      end
    end
  end
end
