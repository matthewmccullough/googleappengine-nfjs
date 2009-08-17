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

require 'appengine-rack'
require 'appengine-tools/web-xml'
require 'appengine-tools/xml-formatter'
require 'fileutils'
require 'yaml'

module AppEngine
  module Admin

    class Application
      attr_reader :root
      
      def initialize(root)
        @root = root
      end

      def path(*pieces)
        File.join(@root, *pieces)
      end
      
      def webinf
        path('WEB-INF')
      end
      
      def webinf_lib
        path('WEB-INF', 'lib')
      end
      
      def generation_dir
        path('WEB-INF', 'appengine-generated')
      end

      def config_ru
        path('config.ru')
      end
      
      def web_xml
        path('WEB-INF', 'web.xml')
      end
      
      def aeweb_xml
        path('WEB-INF', 'appengine-web.xml')
      end
      
      def build_status
        path('WEB-INF', 'appengine-generated', 'build_status.yaml')
      end
      
      def public_root
        path(AppEngine::Rack.app.public_root) if AppEngine::Rack.app.public_root
      end
      
      def persistent_path_token
        path(public_root, '__preserve__')
      end

      def rack_app
        AppEngine::Rack.app
      end
      
    end
    
    class AppBundler
      EXISTING_JRUBY = /^appengine-jruby-.*jar$/
      EXISTING_RACK = /jruby-rack.*jar$/
      EXISTING_APIS = /^appengine-api.*jar$/
      JRUBY_RACK = 'jruby-rack-0.9.4.jar'
      JRUBY_RACK_URL = 'http://kenai.com/projects/jruby-rack/' +
                       "downloads/download/#{JRUBY_RACK}"
      RACKUP = %q{Dir.chdir('..') if Dir.pwd =~ /WEB-INF$/;} +
               %q{eval IO.read('config.ru'), nil, 'config.ru', 1}
      
      def initialize(root_path)
        @app = Application.new(root_path)
      end
      
      def bundle
        create_webinf
        copy_jruby
        copy_rack
        copy_sdk
        convert_config_ru
      end
      
      def app
        @app
      end
      
      def create_webinf
        Dir.mkdir(app.webinf) unless File.exists?(app.webinf)
        Dir.mkdir(app.webinf_lib) unless File.exists?(app.webinf_lib)
        Dir.mkdir(app.generation_dir) unless File.exists?(app.generation_dir)
      end
      
      def create_public
        return if app.public_root.nil?
        Dir.mkdir(app.public_root) unless File.exists?(app.public_root)
        token = app.persistent_path_token
        FileUtils.touch(token) unless File.exists?(token)
      end
      
      def convert_config_ru
        AppEngine::Development.boot_jruby(app.root)
        if !File.exists?(app.config_ru)
          if File.exists?(app.web_xml)
            unless File.exists?(app.aeweb_xml)
              puts "!! Error: you either need a #{app.config_ru} or "
              puts "      #{app.aeweb_xml}."
              exit 1
            end
          else
            # TODO auto generate a config.ru
            puts "!! Error: you need to create #{app.config_ru}."
            exit 1
          end
        else
          generate_xml
          create_public
        end
      end
      
      def copy_jruby
        current_jruby = find_jars(EXISTING_JRUBY)
        if current_jruby.empty?
          puts "=> Installing JRuby"
          require 'appengine-jruby-jars'
          FileUtils.cp([AppEngine::JRubyJars.jruby_jar,
                        AppEngine::JRubyJars.rubygems_jar],
                       app.webinf_lib)
        end
        # TODO else warn if out of date
      end
      
      def copy_rack
        current_rack = find_jars(EXISTING_RACK)
        if current_rack.empty?
          # TODO cache this somewhere
          puts "=> Retrieving jruby-rack"
          require 'open-uri'
          open(JRUBY_RACK_URL) do |src|
            open(File.join(app.webinf_lib, JRUBY_RACK), 'wb') do |dest|
              dest.write(src.read)
            end
          end
        end
      end
      
      def copy_sdk
        current_apis = find_jars(EXISTING_APIS)
        if current_apis.empty?
          puts "=> Installing appengine-sdk"
          require 'appengine-sdk'
          jars = Dir.glob(
              "#{AppEngine::SDK::SDK_ROOT}/lib/user/appengine-api*.jar")
          # TODO if there's more than 1 we need to check the api version.
          FileUtils.cp(jars[0], app.webinf_lib)
        end
      end
      
      private
      
      def find_jars(regex)
        Dir.entries(app.webinf_lib).grep(regex) rescue []
      end

      def valid_build
        return false unless File.exists? app.build_status
        return false unless File.exists? app.web_xml
        return false unless File.exists? app.aeweb_xml
        yaml = YAML.load_file app.build_status
        return false unless yaml.is_a? Hash
        return false unless File.stat(app.config_ru).mtime.eql? yaml[:config_ru]
        return false unless File.stat(app.web_xml).mtime.eql? yaml[:web_xml]  
        return false unless File.stat(app.aeweb_xml).mtime.eql? yaml[:aeweb_xml]
        true
      end

      def generate_xml
        return if valid_build 
        puts "=> Generating configuration files"
        Dir.glob("#{app.webinf_lib}/*.jar").each do |path|
          $: << path
        end
        app_root = app.root
        builder = WebXmlBuilder.new do
          # First configure the basic jruby-rack settings.
          add_jruby_rack_defaults(RACKUP)

          # Now read the user's rackup file
          # TODO generate a skeleton if it's missing
          Dir.chdir(app_root) do
            eval IO.read('config.ru'), nil, 'config.ru', 1
          end
        end
        open(app.web_xml, 'w') do |webxml|
          xml = AppEngine::Rack::XmlFormatter.format(builder.to_xml)
          webxml.write(xml)
        end
        open(app.aeweb_xml, 'w') do |aeweb|
          xml = AppEngine::Rack::XmlFormatter.format(app.rack_app.to_xml)
          aeweb.write(xml)
        end
        yaml = {
            :config_ru => File.stat(app.config_ru).mtime,
            :aeweb_xml => File.stat(app.aeweb_xml).mtime,
            :web_xml   => File.stat(app.web_xml).mtime }
        open(app.build_status, 'w') { |f| YAML.dump(yaml, f) } 
      end
    end

    def self.bundle_app(root_path)
      AppBundler.new(root_path).bundle
    end

  end
end
