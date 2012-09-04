require 'motion_build/builder'
require 'motion_build/config'

module MotionBuild
  class Project
    # Array of source files, required to build the project
    attr_reader :name, :config
    attr_accessor :sources, :frameworks, :builder, :info_plist, :identifier, :short_version, :bundle_signature

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

      @root_rule = Rules::BuildProjectRule.new(self)
      @root_rule.action
    end

    def info_plist
      @info_plist ||= {
        'BuildMachineOSBuild' => `sw_vers -buildVersion`.strip,
        'MinimumOSVersion' => config.get(:deployment_target),
        'CFBundleDevelopmentRegion' => 'en',
        'CFBundleName' => name,
        'CFBundleDisplayName' => name,
        'CFBundleExecutable' => name,
        'CFBundleIdentifier' => identifier,
        'CFBundleInfoDictionaryVersion' => '6.0',
        'CFBundlePackageType' => 'APPL',
        'CFBundleResourceSpecification' => 'ResourceRules.plist',
        'CFBundleShortVersionString' => short_version,
        'CFBundleSignature' => bundle_signature,
        'CFBundleSupportedPlatforms' => ['iPhoneOS'],
        'CFBundleVersion' => version,
        'CFBundleIconFiles' => icons,
        'CFBundleIcons' => {
          'CFBundlePrimaryIcon' => {
            'CFBundleIconFiles' => icons,
            'UIPrerenderedIcon' => prerendered_icon,
          }
        },
        'UIAppFonts' => fonts,
        #'UIDeviceFamily' => device_family_ints.map { |x| x.to_s },
        #'UISupportedInterfaceOrientations' => interface_orientations_consts,
        #'UIStatusBarStyle' => status_bar_style_const,
        #'UIBackgroundModes' => background_modes_consts,
        'DTXcode' => '0431',
        'DTSDKName' => 'iphoneos5.0',
        'DTSDKBuild' => '9A334',
        'DTPlatformName' => 'iphoneos',
        'DTCompiler' => 'com.apple.compilers.llvm.clang.1_0',
        'DTPlatformVersion' => '5.1',
        'DTXcodeBuild' => '4E1019',
        'DTPlatformBuild' => '9B176'
      }
    end

    def identifier
      @identifier ||= "com.yourcompany.#{name.gsub(/\s/, '')}"
    end

    def short_version
      @short_version ||= '1.0'
    end

    def version
      @version ||= '1.0'
    end

    def bundle_signature
      @bundle_signature ||= '????'
    end

    def prerendered_icon
      @prerendered_icon ||= false
    end

    def icons
      @icons ||= []
    end

    def fonts
      @fonts ||= []
    end
  end
end
