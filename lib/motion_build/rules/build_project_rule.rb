module MotionBuild ; module Rules

  class BuildProjectRule < MotionBuild::Rule
    def active?
      File.mtime(project.config.get(:project_config)) >= File.mtime(project.config.get(:build_dir))
    end

    def pre_dependencies
      FileUtils.mkdir_p(project.config.get(:build_dir)) unless File.exists?(project.config.get(:build_dir))
      self.forced = active?
    end

    def run
      FileUtils.touch(project.config.get(:build_dir))
      # XXX action! if project file is newer than :build_dir

      # prepare bridge support files
      # build vendor libs && add them to bs

      # build CompileRubySourceRule for sources
      # build RenderErbRule for init.mm
      # build CompileCXXSourceRule for init.mm
      # build RenderErbRule for main.mm
      # build CompileCXXSourceRule for main.mm
      # prepare bundle
      # build LinkExecutableRule for sources & templete
    end

    def initialize(project)
      super(project)
      setup_dependencies
    end

    private
    def setup_dependencies
      compile_rules = project.sources.map do |src|
        CompileRubySourceRule.new(project, src, archs: project.config.get(:build_architectures), bridge_support_files: bs_files)
      end

      dependencies.concat(compile_rules)


      init_file = RenderErbFileRule.new(project, File.join(File.dirname(__FILE__), '..', '..', '..', 'assets', 'init.mm.erb'), nil) do |rule, ctx|
        rule.context = { init_functions: compile_rules.map { |r| r.init_func_name } }
      end

      compile_init_file = CompileClangSourceRule.build(project, init_file.destination)
      compile_init_file.dependencies << init_file

      dependencies << compile_init_file


      main_file = RenderErbFileRule.new(project, File.join(File.dirname(__FILE__), '..', '..', '..', 'assets', 'main.mm.erb'), {})
      # TODO: fix the hash

      compile_main_file = CompileClangSourceRule.build(project, main_file.destination)
      compile_main_file.dependencies << main_file
      dependencies << compile_main_file

      prepare_bundle = PrepareBundleRule.new(project, project.config.get(:name))
      dependencies << prepare_bundle

      link_executable = LinkObjectsRule.new(project,
        compile_rules.map { |r| r.destination } + [compile_init_file.destination, compile_main_file.destination],
        File.join(prepare_bundle.bundle_path, project.config.get(:name)))

      dependencies << link_executable

      plist_rule = RenderPlistRule.new(project, project.info_plist, File.join(prepare_bundle.bundle_path, 'Info.plist'), :binary)
      dependencies << plist_rule
    end

    def bs_files
      frameworks = ['RubyMotion', *project.frameworks].uniq

      @bs_files = []
      frameworks.each do |framework|
        acceptable_sdk_versions.each do |ver|
          bs_fn = File.join(project.config.get(:motion_data_dir), ver, 'BridgeSupport', framework + '.bridgesupport')
          @bs_files << bs_fn if File.exist?(bs_fn)
        end
      end
      @bs_files
    end

    def acceptable_sdk_versions
      @available_versions ||= Dir.glob(File.join(project.config.get(:motion_data_dir), '*')).
        select{ |path| File.directory?(path) }.map { |path| File.basename path }

      @acceptable_versions = @available_versions.reject { |ver| ver >= project.config.get(:deployment_target) && ver <= project.config.get(:base_sdk) }
    end
  end

end ; end
