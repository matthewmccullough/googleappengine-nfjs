#! /usr/bin/ruby
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

require 'appengine-sdk'

module AppEngine
  module Development
    
    class << self
      def boot_jruby(root=nil)
        unless defined?(JRUBY_VERSION)
          require 'rubygems'
          require 'appengine-jruby-jars'

          jars = [
            AppEngine::JRubyJars.jruby_jar,
            AppEngine::JRubyJars.rubygems_jar,
            AppEngine::SDK::TOOLS_JAR,
            ]

          ENV['GEM_HOME'] = Gem.dir
          exec_jruby(root, jars, [$0] + ARGV)
        end
      end
    
      def boot_app(root, args)
        root = File.expand_path(root)

        jars = AppEngine::SDK::RUNTIME_JARS

        jruby_args = %w(-rappengine_boot) + args

        ENV['APPLICATION_ROOT'] = root
        ENV.delete 'GEM_HOME'
        exec_jruby(root, jars, jruby_args)
      end
      
      def exec_jruby(root, jars, args)
        app_jars = root ? Dir.glob("#{root}/WEB-INF/lib/*.jar") : []
        classpath = (app_jars + jars).join(File::PATH_SEPARATOR)
        utf = "-Dfile.encoding=UTF-8"
        java_command = %W(java #{utf} -cp #{classpath} org.jruby.Main) + args
        if ENV['VERBOSE']
          puts java_command.map {|a| a.inspect}.join(' ')
        end
        exec *java_command
      end
    end
  end
end