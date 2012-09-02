# Options

# Project name
option :name do
  ''
end

# The root directory for RubyMotion
option :motion_data_dir, validate: :existing_directory do |cfg|
  '/Library/RubyMotion/data'
end

# The root directory for the source tree
option :source_dir, validate: :existing_directory do |cfg|
  Dir.pwd
end

# The destination build directory for current platform
option :build_dir do |cfg|
  File.join(cfg.get(:source_dir), 'mb-build', cfg.get(:platform))
end

# THe destination directory for object files and intermediates of such
option :build_dir_objects do |cfg|
  File.join(cfg.get(:build_dir), 'objs')
end

# The project config file
option :project_config, validate: :existing_file do |cfg|
  File.join(cfg.get(:source_dir), 'motion.thor')
end

# The deployment target iOS version
option :deployment_target, validate: :ios_version do |cfg|
  cfg.get(:available_targets).last
end

# The available iOS targets
option :available_targets, no_override: true do |cfg|
  Dir.glob(File.join(cfg.get(:motion_data_dir), '*')).delete_if { |d| ! File.directory? d }.map { |d| File.basename d }
end

# The base iOS SDK for build
option :base_sdk, validate: :ios_version do |cfg|
  cfg.get(:available_targets).last
end

# Target build architectures
option :build_architectures, validate: :arch_kernel_exists do |cfg|
  Dir.glob(File.join(
    cfg.get(:motion_data_dir),
    cfg.get(:base_sdk),
    cfg.get(:platform),
    'kernel-*.bc')).map { |d| File.basename(d) =~ /^kernel-(.+)\.bc/; $~[1] }
end

option :clang_flags, no_override: true do |cfg|
  [*(cfg.get(:build_architectures).map { |a| ['-arch', a] }.flatten),
    '-isysroot', cfg.get(:system_root),
    "-miphoneos-version-min=#{cfg.get(:deployment_target)}",
    *cfg.get(:framework_search_paths)]
end

# CFLAGS for CompileCPPSourceRule (all)
option :cflags, no_override: true do |cfg|
  [*cfg.get(:clang_flags),
    '-fexceptions', '-fblocks', '-fobjc-legacy-dispatch', '-fobjc-abi-version=2',
    *cfg.get(:other_cflags)]
end

# LDFLAGS for LinkObjectsRule (all)
option :ldflags, no_override: true do |cfg|
  [*cfg.get(:clang_flags), *cfg.get(:other_ldflags)]
end

# CFLAGS for CompileCPPSourceRule (user-defined)
option :other_cflags do |cfg|
  []
end

# LDFLAGS for LinkObjectsRule (user-defined)
option :other_ldflags do |cfg|
  []
end

# Platform root dir
option :system_root, validate: :existing_directory, no_override: true do |cfg|
  File.join(cfg.get(:developer_dir), 'Platforms', "#{cfg.get(:platform)}.platform", 'Developer', 'SDKs',
    "#{cfg.get(:platform)}#{cfg.get(:base_sdk)}.sdk")
end

# Target platform
option :platform, validate: :platform

# Developer dir
option :developer_dir, validate: :existing_directory do |cfg|
  xcodes = Dir.glob('/Applications/Xcode*.app').reverse # DP-s go first
  dev_dirs = xcodes.map { |xc| File.join(xc, 'Contents', 'Developer') }
  dev_dirs << '/Developer'
  dev_dirs.each { |dir| File.directory?(dir) ? dir : nil }.compact.first
end

option :framework_search_paths, no_override: true do |cfg|
  ['-F' + File.join(cfg.get(:system_root), 'System', 'Library', 'Frameworks')]
end

option :frameworks do |cfg|
  ['UIKit', 'Foundation', 'CoreGraphics']
end

# Validators
validator :existing_directory do |option, value|
  raise ValidationError, "#{option} directory is set to '#{value}', but the directory does not exist" unless File.directory?(value)
end

validator :existing_file do |option, value|
  raise ValidationError, "#{option} file is set to '#{value}', but the file does not exist" unless File.file?(value)
end

validator :ios_version do |option, value, cfg|
  raise ValidationError, "#{option} has the iOS target set to '#{value}', which is not supported" unless cfg.get(:available_targets).include?(value)
end

validator :arch_kernel_exists do |option, value, cfg|
  kernels = value.map { |a| File.join(cfg.get(:motion_data_dir), cfg.get(:base_sdk), cfg.get(:platform), "kernel-#{a}.bc") }
  fail = kernels.map { |k| File.file?(k) ? nil : true }.compact.first
  raise ValidationError, "#{option} set to target '#{value.join(', ')}', which does not exist" if fail
end

validator :platform do |option, value|
  plat = ['iPhoneOS', 'iPhoneSimulator']
  raise ValidationError, "#{option} set to platform '#{value}', which does not exist" unless plat.include?(value)
end
