module Motion ; module Build ; module Rules

  class UnlinkFileRule < Motion::Build::Rule
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

end ; end ; end
