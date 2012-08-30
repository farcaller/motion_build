require 'motion_build/builder'

module Motion ; module Build
  class Project
    # Array of source files, required to build the project
    attr_reader :name, :config
    attr_accessor :sources, :frameworks, :builder

    def initialize(name)
      @name = name
      @sources = []
      @frameworks = ['Foundation', 'CoreGraphics', 'UIKit']
      @config = {}
    end
    
    def build
      @builder = Builder.new
      @config[:source_dir] = File.absolute_path('app')
      @config[:build_dir] = File.absolute_path('mb-build/iPhoneSimulator/objs')
      @config[:config_file] = File.absolute_path('motion.thor')
      @config[:motion_data_dir] = '/Library/RubyMotion/data'
      @config[:deployment_target] = '6.0'
      @config[:base_sdk] = '6.0'
      @config[:build_architectures] = ['i386']
      @config[:build_platform] = 'iPhoneSimulator'
      @config[:build_cflags] = [
        '-arch', @config[:build_architectures].first,
        '-isysroot',
        '/Applications/Xcode45-DP4.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk',
        '-miphoneos-version-min=6.0',
        '-F/Applications/Xcode45-DP4.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.0.sdk/System/Library/Frameworks',
        '-fexceptions', '-fblocks', '-fobjc-legacy-dispatch', '-fobjc-abi-version=2'
      ]

      FileUtils.mkdir_p(@config[:build_dir]) unless File.exists?(@config[:build_dir])

      @root_rule = Rules::BuildProjectRule.new(self)

      if File.mtime(@config[:config_file]) < File.mtime(@config[:build_dir])
        @root_rule.action
      else
        puts "force start"
        @root_rule.action!
      end
    end
  end
end ; end
