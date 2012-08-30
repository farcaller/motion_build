module Motion ; module Build ; module Rules

  class BuildProjectRule < Motion::Build::Rule
    def active?
      true
    end

    def run
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
        CompileRubySourceRule.new(project, src, archs: project.config[:build_architectures], bridge_support_files: bs_files)
      end

      dependencies.concat(compile_rules)

      init_file = CompileErbFileRule.new(project, File.join(File.dirname(__FILE__), '..', '..', '..', 'assets', 'init.mm.erb'), nil) do |rule, ctx|
        rule.context = { init_functions: compile_rules.map { |r| r.init_func_name } }
      end

      compile_init_file = CompileCPPSourceRule.new(project, init_file.destination)
      compile_init_file.dependencies << init_file

      dependencies << compile_init_file

    end

    def bs_files
      frameworks = ['RubyMotion', *project.frameworks].uniq

      @bs_files = []
      frameworks.each do |framework|
        acceptable_sdk_versions.each do |ver|
          bs_fn = File.join(project.config[:motion_data_dir], ver, 'BridgeSupport', framework + '.bridgesupport')
          @bs_files << bs_fn if File.exist?(bs_fn)
        end
      end
      @bs_files
    end

    def acceptable_sdk_versions
      @available_versions ||= Dir.glob(File.join(project.config[:motion_data_dir], '*')).
        select{ |path| File.directory?(path) }.map { |path| File.basename path }

      @acceptable_versions = @available_versions.reject { |ver| ver >= project.config[:deployment_target] && ver <= project.config[:base_sdk] }
    end
  end

end ; end ; end
