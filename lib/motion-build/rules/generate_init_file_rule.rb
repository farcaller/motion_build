require 'erb'

module Motion ; module Build ; module Rules

  class GenerateInitFileRule < Motion::Build::FileRule
    attr_reader :destination, :init_functions

    def output_extension
      '.mm'
    end

    def run
      e = ERB.new(@template)
      open(destination, 'w') { |f| f.write(e.result(binding)) }
    end

    def initialize(project, destination, init_functions)
      super(project)
      @destination = destination
      @init_functions = init_functions
      @template = open(File.join(File.dirname(__FILE__), '..', '..', '..', 'assets', 'init.mm.erb')).read
    end

    def relative_destination
      @destination
    end
  end

end ; end ; end
