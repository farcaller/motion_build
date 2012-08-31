require 'motion_build/project'
require 'motion_build/rules'

KERNEL_FILE_PATH = '/Library/RubyMotion/data/6.0/iPhoneSimulator/kernel-i386.bc'

describe MotionBuild::Rules::EmitLLVMBitcodeRule do
  before :each do
    @project = MotionBuild::Project.new("Hello World")
    @project.config.override(:source_dir, Dir.mktmpdir)
    @project.config.override(:build_dir, Dir.mktmpdir)

    @project.config.override(:platform, 'iPhoneSimulator')
    @project.config.override(:base_sdk, '6.0')

    @r = MotionBuild::Rules::EmitLLVMBitcodeRule.new(@project, File.join(@project.config.get(:source_dir), 'test.rb'), arch: 'i386', init_func: 'MREP_C2797146C50F4A89A85C57D08BBE5123', bridge_support_files: BRIDGE_SUPPORT_STUB)
  end

  it "should input '.rb' files and output '.bc' files" do
    @r.input_extension.should == '.rb'
    @r.output_extension.should == '.bc'
  end

  it "should resolve path to kernel file" do
    @r.send(:kernel_file).should == KERNEL_FILE_PATH
  end

  it "should map bridge support flags" do
    @r.send(:bs_flags).should == BRIDGE_SUPPORT_FLAGS_STUB
  end

  it "should invoke ruby binary with correct arguments" do
    @project.builder = builder_mock
    @project.builder.should_receive(:run).with('ruby', [
      *BRIDGE_SUPPORT_FLAGS_STUB,
      '--emit-llvm',
      File.join(@project.config.get(:build_dir_objects), 'test.bc'),
      'MREP_C2797146C50F4A89A85C57D08BBE5123',
      File.join(@project.config.get(:source_dir), 'test.rb'),
    ], { env: { 'VM_KERNEL_PATH' => KERNEL_FILE_PATH}})
    @r.action
  end

  after :each do
    FileUtils.remove_dir @project.config.get(:source_dir)
    FileUtils.remove_dir @project.config.get(:build_dir)
  end
end
