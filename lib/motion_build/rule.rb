module MotionBuild
  class Rule
    attr_reader :dependencies, :project

    def initialize(project)
      @project = project
      @dependencies = []
    end

    # The *active* rule requires its *action* to be performed this build cycle
    def active?
      false
    end

    def action!
      # project.builder.notify('', self.class.to_s, "dependencies!")
      @dependencies.each { |dep| dep.action! }
      # project.builder.notify('', self.class.to_s, "run!")
      run
    end

    def action
      # project.builder.notify('', self.class.to_s, "dependencies")
      @dependencies.each { |dep| dep.action }
      # project.builder.notify('', self.class.to_s, "run")
      run if active?
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
  end
end
