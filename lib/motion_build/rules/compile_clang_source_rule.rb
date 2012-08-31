module MotionBuild ; module Rules

  class CompileClangSourceRule
    def self.build(project, source)
      case File.extname(source)
      when '.c'
        CompileCSourceRule.new(project, source)
      when '.m'
        CompileMSourceRule.new(project, source)
      when '.cpp'
        CompileCPPSourceRule.new(project, source)
      when '.mm'
        CompileMMSourceRule.new(project, source)
      else
        raise ArgumentError, "Unknown extension '#{File.extname(source)}'"
      end
    end

    def initialize(project, source)
      raise RuntimeError, "You cannot create an instance with #new, you must use #build"
    end

    module CompileGeneric
      def output_extension
        '.o'
      end

      def run
        project.builder.notify(clang, source, destination)
        project.builder.run(clang, [source, *project.config.get(:cflags), '-c', '-o', destination])
      end

      def initialize(project, source)
        super(project, source)
      end
    end

    class CompileCSourceRule < MotionBuild::ObjectFileRule
      include CompileGeneric
      def input_extension; '.c'; end
      def clang; 'clang'; end
    end

    class CompileMSourceRule < MotionBuild::ObjectFileRule
      include CompileGeneric
      def input_extension; '.m'; end
      def clang; 'clang'; end
    end

    class CompileCPPSourceRule < MotionBuild::ObjectFileRule
      include CompileGeneric
      def input_extension; '.cpp'; end
      def clang; 'clang++'; end
    end

    class CompileMMSourceRule < MotionBuild::ObjectFileRule
      include CompileGeneric
      def input_extension; '.mm'; end
      def clang; 'clang++'; end
    end

  end

end ; end
