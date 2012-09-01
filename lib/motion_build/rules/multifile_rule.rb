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
      return true unless source # run if we have no source
      return true unless destination # run if we have no destination
      return true unless File.exist?(destination) # run if destination file doesn't exist

      sources.each { |src| return true if File.mtime(src) <= File.mtime(destination) }
      
      false
    end
  end

end ; end
