require 'simplecov'
SimpleCov.start

require 'bundler'

Bundler.require(:default, :test)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

# builder mock helpers

def builder_mock
  d = double('builder')
  d.stub(:notify)
  d
end

# common globals

BRIDGE_SUPPORT_STUB = [
  "/Library/RubyMotion/data/6.0/BridgeSupport/RubyMotion.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/UIKit.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/CoreVideo.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/CoreImage.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/Security.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/Foundation.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/CoreGraphics.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/CoreFoundation.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/ImageIO.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/QuartzCore.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/CoreText.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/MobileCoreServices.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/CFNetwork.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/Accelerate.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/SystemConfiguration.bridgesupport",
  "/Library/RubyMotion/data/6.0/BridgeSupport/CoreData.bridgesupport",
]
BRIDGE_SUPPORT_FLAGS_STUB = [
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/RubyMotion.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/UIKit.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/CoreVideo.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/CoreImage.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/Security.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/Foundation.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/CoreGraphics.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/CoreFoundation.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/ImageIO.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/QuartzCore.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/CoreText.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/MobileCoreServices.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/CFNetwork.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/Accelerate.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/SystemConfiguration.bridgesupport",
  "--uses-bs", "/Library/RubyMotion/data/6.0/BridgeSupport/CoreData.bridgesupport",
]
