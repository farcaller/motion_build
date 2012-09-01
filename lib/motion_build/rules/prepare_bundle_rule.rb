module MotionBuild ; module Rules

  class PrepareBundleRule < MotionBuild::Rule
    attr_reader :bundle_name

    def active?
      ! File.exist?(bundle_path)
    end

    def run
      project.builder.notify('mkdir', nil, bundle_name)
      FileUtils.mkdir_p(bundle_path)
      project.config.override(:bundle_path, bundle_path)
    end

    def initialize(project, bundle_name)
      super(project)
      @bundle_name = bundle_name

      project.config.load_options do |c|
        c.option :bundle_path, verify: :existing_directory do |cfg| "" end
      end
    end

    def bundle_path
      File.join(project.config.get(:build_dir), "#{bundle_name}.app")
    end
  end

end ; end
