module MotionBuild ; module Rules

  class MultifileRule < MotionBuild::ObjectFileRule
    attr_reader :sources, :destination

    def run
      raise RuntimeError, "You must inplement a subclass!"
    end

    def initialize(project, sources, destination)
      super(project)
      @sources = sources
      @destination = destination
    end

    def active?
      return true unless sources # run if we have no source
      return true unless destination # run if we have no destination
      return true unless File.exist?(destination) # run if destination file doesn't exist

      return true if sources.map { |src| true if File.mtime(src) > File.mtime(destination) }.first
      
      false
    end
  end

end ; end
