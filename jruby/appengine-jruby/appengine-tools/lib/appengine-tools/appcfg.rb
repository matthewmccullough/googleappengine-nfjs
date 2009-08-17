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
require 'appengine-tools/boot'
require 'appengine-tools/bundler'
require 'yaml'

module AppEngine
  module Admin
    if defined? Java
      AppCfg = AppEngine::SDK.load_appcfg
      import Java.ComGoogleAppengineToolsAdmin.AppAdminFactory 
      import Java.ComGoogleAppengineToolsAdmin.AppVersionUpload
      import Java.ComGoogleAppengineToolsUtil.Logging
    
      class JRubyAppVersionUpload < AppVersionUpload
        def initialize(connection, app)
          @connection = connection
          @app = app
          super(connection, app)
        end
      
        def getIndexYaml
          indexes = merge_indexes
          if indexes
            return indexes.to_yaml
          end
          nil
        end
      
        def getCronYaml
          cron = File.join(app.path, 'cron.yaml')
          if File.exists?(cron)
            return cron.to_yaml
          end
          nil
        end
      
        def merge_indexes
          if @app.indexes_xml
            indexes = YAML.load(@app.indexes_xml.to_yaml)['indexes']
          end
          indexes ||= []
          index_yaml = File.join(@app.path, 'index.yaml')
          if File.exist?(index_yaml)
            manual_indexes = YAML.load_file(index_yaml)['indexes'] || []
            manual_indexes.each do |index|
              indexes << index unless indexes.include?(index)
            end
          end
          if indexes.size > 0
            {'indexes' => indexes}
          else
            nil
          end
        end
      end
    end
    
    class JRubyAppCfg
      NO_XML_COMMANDS = [ 'version' ]
      RUBY_COMMANDS = ['bundle', 'gem', 'help', 'run']
      COMMAND_SUMMARY = <<EOF
  run: run jruby in your application environment.
  gem: run rubygems for your application.
  bundle: package your application for deployment.
The 'gem' and 'run' commands assume the app directory is the current directory.
EOF
      class << self
        def main(args)
          command, parsed_args = parse_args(args)
          if RUBY_COMMANDS.include? command
            send(command, *parsed_args)
            return
          end
          if command && ! NO_XML_COMMANDS.include?(command)
            AppEngine::Admin.bundle_app(parsed_args[0])
          end
          if !RUBY_COMMANDS.include?(command)
            puts "running AppCfg"
            run_appcfg(args)
          end
        end
        
        def run_appcfg(args)
          factory = AppAdminFactory.new
          factory.setAppVersionUploadClass(JRubyAppVersionUpload)
          Logging.initializeLogging
          AppCfg.new(factory, args.to_java(java.lang.String))
        end
        
        def bundle(path)
          AppEngine::Admin.bundle_app(path)
        end
        
        def bundle_help
          help = <<EOF
#{$0} bundle app_dir

Generates files necessary to run an application as a Java Servlet.
This is run automatically when necessary, so you should not
need to run it manually.

EOF
        end
        
        def gem(*args)
          AppEngine::Development.boot_jruby
          require 'rubygems'
          require 'rubygems/command_manager'
          Gem.configuration = Gem::ConfigFile.new(args)
          Gem.use_paths('.gems')
          Gem::Command.add_specific_extra_args(
              'install', %w(--no-rdoc --no-ri))
          begin
            Gem::CommandManager.instance.run(Gem.configuration.args)
          rescue Gem::SystemExitException => e
            exit e.exit_code unless e.exit_code == 0
          end
          unless Dir.glob('.gems/specifications/*.gemspec').empty?
            Dir.mkdir 'WEB-INF' unless File.exists? 'WEB-INF'
            Dir.mkdir 'WEB-INF/lib' unless File.exists? 'WEB-INF/lib'
            Dir.chdir '.gems'
            command = %w(jar cf ../WEB-INF/lib/gems.jar gems specifications)
            if !system(*command)
              puts 'Error running jar command.'
              exit $?
            end
          end
        end
        
        def gem_help
          help = <<EOF
#{$0} gem [rubygems arguments]


Configures rubygems for this application and bundles the gems into a .jar file.
Must be run from the application directory.

EOF
        end
        
        def run(*args)
          AppEngine::Development.boot_app('.', args)
        end
        
        def run_help
          help = <<EOF
#{$0} run [ruby args]


Starts the jruby interpreter within your application's environment.
Use `#{$0} run -S command` to run a command such as rake or irb.
Must be run from the application directory, after running bundle.

EOF
        end

        def help(command=nil)
          puts
          if command != 'help' && RUBY_COMMANDS.include?(command)
            puts send("#{command}_help")
          else
            java_args = %W(java -cp #{AppEngine::SDK::TOOLS_JAR})
            java_args << 'com.google.appengine.tools.admin.AppCfg'
            java_args << 'help'
            java_args << command if command
            print_help(%x{#{java_args.map{|x| x.inspect}.join(' ')}}, !command)
          end
        end
        
        def print_help(help, summary)
          help.gsub!('AppCfg', $0)
          count = 0
          help.each_line do |line|
            line.chomp!
            if summary && line.size > 0 && line.lstrip == line
              count += 1
              print COMMAND_SUMMARY if count == 3
            end
            puts line
          end
        end

        def parse_args(args)
          if RUBY_COMMANDS.include?(args[0])
            return [args[0], args[1, args.length]]
          elsif args.empty? || !(%w(-h --help) & args).empty?
            return ['help', []]
          elsif args[-3] == 'request_logs'
            command = args[-3]
            path = args[-2]
          else
            command = args[-2]
            path = args[-1]
          end
          return [command, [path]]
        end
      end
    end
  end
end