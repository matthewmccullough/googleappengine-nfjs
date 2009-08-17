#!/usr/bin/ruby
# Copyright:: Copyright 2009 Google Inc.
# Original Author:: John Woodell (mailto:woodie@google.com)
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

require 'appengine-sdk'
require 'appengine-tools/boot'
require 'appengine-tools/bundler'

module AppEngine
  module Development
    DEV_APPSERVER = 'com.google.appengine.tools.development.DevAppServerMain'
    class JRubyDevAppserver
      class << self
        def run(args)
          path = args[-1] || '.'
          if args.length > 0 and File::directory?(args[-1])
            unless ENV['BOOTING_DEVAPPSERVER']
              puts  "=> Booting DevAppServer"
              puts  "=> Press Ctrl-C to shutdown server"
              ENV['BOOTING_DEVAPPSERVER'] = 'true'
            end
            AppEngine::Admin.bundle_app(path)
          end
          AppEngine::Development.boot_jruby
          args.unshift(DEV_APPSERVER)
          jruby_home = get_jruby_home(args[-1])
          if jruby_home
            args.unshift("--jvm_flag=-Djruby.home=#{jruby_home}")
          end
          AppEngine::SDK.load_kickstart.main(args.to_java(:string))
        end
        
        def get_jruby_home(path)
          return unless path
          Dir.chdir("#{path}/WEB-INF/lib") do
            jars = Dir.glob("appengine-jruby-*.jar").grep(
                /^appengine-jruby-\d+[.]\d+[.]\d+[.]jar$/)
            if !jars.empty?
              jar = File.expand_path(jars[0])
              return "file:/#{jar}!/META-INF/jruby.home"
            end
          end
          return nil
        end
      end
    end
  end
end
