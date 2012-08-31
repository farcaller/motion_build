module MotionBuild ; module Rules

  class LipoRule < MotionBuild::ObjectFileRule
    attr_reader :sources, :destination

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
