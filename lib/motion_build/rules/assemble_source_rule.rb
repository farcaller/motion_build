module MotionBuild ; module Rules

  class AssembleSourceRule < MotionBuild::FileRule
    attr_reader :arch

    def input_extension
      '.s'
    end

    def output_extension
      '.o'
    end

    def run
      project.builder.notify('gcc', source, destination)
      project.builder.run('gcc', ['-fexceptions', '-c', '-arch', arch, source, '-o', destination])
    end

    def initialize(project, source, options)
      super(project, source)
      @arch = options[:arch] || raise(ArgumentError, "Architecture is not defined")
    end
  end

end ; end
