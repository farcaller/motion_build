module Motion ; module Build ; module Rules

  class CompileCPPSourceRule < Motion::Build::FileRule
    def input_extension
      '.mm'
    end

    def output_extension
      '.o'
    end

    def run
      project.builder.notify('clang++', source, destination)
      project.builder.run('clang++', [source, *project.config[:build_cflags], '-c', '-o', destination])
    end

    def initialize(project, source)
      super(project, source)
    end
  end

end ; end ; end
