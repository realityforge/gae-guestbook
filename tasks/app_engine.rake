module Buildr
  module GoogleAppEngine

    class << self

      def version
        "1.5.3"
      end

      # The specs for requirements
      def dependencies
        [
            "com.google.appengine:appengine-api-1.0-sdk:jar:#{version}",
            "com.google.appengine:appengine-tools-sdk:jar:#{version}"
        ]
      end

      def app_cfg(war_file, args, options = { })
        cp = Buildr.artifacts(self.dependencies).each(&:invoke).map(&:to_s)

        war_file.invoke

        unzip_dir = "#{war_file.to_s}-exploded"
        Buildr.unzip(unzip_dir => war_file.to_s).extract

        args = args.dup
        args << unzip_dir

        begin
          Java::Commands.java 'com.google.appengine.tools.admin.AppCfg', *(args + [{ :classpath => cp, :properties => options[:properties], :java_args => options[:java_args] }])
        rescue => e
          raise e if options[:fail_on_error]
        end
      end
    end

    class Config
      def enabled?
        File.exist?(project._(:source, :main, :webapp, "WEB-INF/appengine-web.xml"))
      end


      attr_writer :sdk_dir

      def sdk_dir
        @sdk_dir || (raise "gae.sdk_dir must be specified")
      end

      protected

      def initialize(project)
        @project = project
      end

      attr_reader :project
    end

    module ProjectExtension
      include Extension

      def gae
        @gae ||= Buildr::GoogleAppEngine::Config.new(project)
      end

      after_define do |project|
        if project.gae.enabled?
          project.packages.each do |pkg|
            if pkg.to_s =~ /\.war$/
              desc "Deploy wars to Google App Engine"
              project.task("gae:deploy") do
                puts "AppEngine: Deploying application..."
                Buildr::GoogleAppEngine.app_cfg(pkg, ["update"], :properties => {"appengine.sdk.root" => project.gae.sdk_dir})
              end
            end
          end
        end
      end
    end
  end
end

class Buildr::Project
  include Buildr::GoogleAppEngine::ProjectExtension
end
