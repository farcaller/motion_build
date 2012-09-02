module MotionBuild
  class Rule
    attr_reader :dependencies, :project
    attr_writer :forced

    def initialize(project)
      @project = project
      @dependencies = []
      @forced = false
    end

    # The *active* rule requires its *action* to be performed this build cycle
    def active?
      false
    end

    def forced?
      @forced
    end

    def action!
      self.forced = true
      action
    end

    def action
      pre_dependencies
      @dependencies.each { |dep| forced? ? dep.action! : dep.action }
      post_dependencies
      run if forced? || active?
    end

    def inspect_dependencies(*args)
      depth = args.count == 1 ? args.first : 0
      ' '*depth + "<#{self.class}" +
      if dependencies.count > 0
        " [\n" + dependencies.map { |d| d.inspect_dependencies(depth+2) }.join(",\n") + "\n#{' '*depth}]"
      else
        ''
      end +
      ">"
    end

    protected
    def run
    end

    def pre_dependencies
    end

    def post_dependencies
    end
  end
end
