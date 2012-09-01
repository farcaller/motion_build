module MotionBuild ; module Rules

  class LipoRule < MultifileRule
    def input_extension
      '.o'
    end

    def output_extension
      '.o'
    end

    def run
      project.builder.notify('lipo', sources, destination)
      project.builder.run('lipo', ['-create', *sources, '-output', destination])
    end
  end

end ; end
