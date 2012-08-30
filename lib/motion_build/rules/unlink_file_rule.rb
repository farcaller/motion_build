module MotionBuild ; module Rules

  class UnlinkFileRule < MotionBuild::Rule
    attr_reader :target
    def active?
      File.exist?(target)
    end

    def run
      project.builder.notify('rm', target, nil)
      project.builder.run('rm', [target])
    end

    def initialize(project, target)
      super(project)
      @target = target
    end
  end

end ; end
