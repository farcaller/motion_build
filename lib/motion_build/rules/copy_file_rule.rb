module MotionBuild ; module Rules

  class CopyFileRule < MotionBuild::FileRule
    attr_reader :destination
    
    def run
      project.builder.notify('cp', source, destination)
      project.builder.run('cp', [source, destination])
    end

    def initialize(project, source, destination)
      super(project, source)
      @destination = destination
    end
  end

end ; end
