module MotionBuild

  # Config class provides a layered approach to access project-specific options.
  # The exact values that you get from config are based on what you have in
  # project file, what is resolved for current build action, and what is the
  # current task.
  class Config
    attr_accessor :validate
    def initialize
      @local_options = {}
      @validate = true

      @options = {}
      @validators = {}

      load_options(File.join(File.dirname(__FILE__), 'config_options.dsl.rb'))
    end

    def override(opt_name, value)
      @local_options[opt_name] = value
    end

    def get(opt_name)
      opt = @options[opt_name]
      raise RuntimeError, "Unknown option '#{opt_name}'" unless opt
      
      local_opt = @local_options[opt_name]
      raise RuntimeError, "Cannot override option '#{opt_name}'" if local_opt && opt[:no_override]
      return local_opt if local_opt && validate!(opt, local_opt)

      val = opt.value(self)
      return val if validate!(opt, val)
    end

    def validate!(opt, value)
      return true unless @validate
      return true unless opt[:validate]
      validator_block = @validators[opt[:validate]]
      validator_block.call(opt.name, value, self)
      true
    end

    def load_options(*args, &block)
      raise RuntimeError, "You must specify either a filename or a block" if (args.count >= 1 && block_given?) || (args.count == 0 && ! block_given?)
      dsl = DSLLoader.new
      if block_given?
        dsl.instance_eval(&block)
      else
        dsl.instance_eval(open(args.first).read, args.first, 1)
      end
      @options.merge!(dsl.options)
      @validators.merge!(dsl.validators)
    end

    private
    class ValidationError < RuntimeError; end

    class DSLLoader
      attr_reader :options, :validators
      def initialize
        @options = {}
        @validators = {}
      end

      def option(name, *params, &block)
        params = params.first || {}
        @options[name] = Option.new(name, params, block)
      end

      def validator(name, &block)
        @validators[name] = block
      end
    end

    class Option
      attr_reader :name

      def initialize(name, params, block)
        @name = name
        @params = params
        @block = block
      end

      def [](p)
        @params[p]
      end

      def value(cfg)
        @block.call(cfg)
      end
    end
  end

end
