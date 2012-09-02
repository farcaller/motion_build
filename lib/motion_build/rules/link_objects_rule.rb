module MotionBuild ; module Rules

  class LinkObjectsRule < MultifileRule
    def input_extension
      '.o'
    end

    def output_extension
      ''
    end

    def run
      project.builder.notify('ld', sources, destination)
      project.builder.run('clang++', ['-o', destination, *sources, *project.config.get(:ldflags),
        "-L#{File.join(project.config.get(:motion_data_dir), project.config.get(:base_sdk), project.config.get(:platform))}",
        '-lmacruby-static', '-lobjc', '-licucore',
        *frameworks])
    end

    private
    def frameworks
      @frameworks ||= project.config.get(:frameworks).map { |f| ['-framework', f] }.flatten
    end
  end

end ; end
