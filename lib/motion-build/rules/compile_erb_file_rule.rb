require 'erb'

module Motion ; module Build ; module Rules

  class CompileErbFileRule < Motion::Build::FileRule
    attr_accessor :context

    def input_extension
      '.erb'
    end

    def output_extension
      File.extname(File.extname(source))
    end

    def run
      project.builder.notify('erb', source, destination)
      @context = @block.call(self, @context) if @block
      e = ERB.new(template)
      open(destination, 'w') { |f| f.write(e.result(TinyContext.new(context).get_binding)) }
    end

    def initialize(project, source, context, &block)
      super(project, source)
      @context = context
      @block = block if block_given?
      raise ArgumentError, "No context and no bock given" unless @context || @block
    end

    private
    def template
      @template ||= open(source).read
    end

    protected
    def relative_destination
      destination_file
    end

    def destination_file
      File.basename(source, input_extension)
    end

    class TinyContext
      def initialize(ctx)
        @ctx = ctx
      end

      def get_binding
        binding()
      end

      def method_missing(m)
        @ctx[m]
      end
    end
  end

end ; end ; end
