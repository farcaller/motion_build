require 'motion_build/builder'
require 'motion_build/config'

module MotionBuild
  class Project
    # Array of source files, required to build the project
    attr_reader :name, :config
    attr_accessor :sources, :frameworks, :builder

    def initialize(name)
      @name = name
      @sources = []
      @frameworks = ['Foundation', 'CoreGraphics', 'UIKit']
      @config = Config.new
    end
    
    def build
      @builder = Builder.new
      @config.override(:platform, 'iPhoneSimulator')
      @config.override(:project_config, "motion.thor")
      @config.override(:name, @name)

      FileUtils.mkdir_p(@config.get(:build_dir)) unless File.exists?(@config.get(:build_dir))
      @root_rule = Rules::BuildProjectRule.new(self)

      @root_rule.action
    end
  end
end
