require 'motion_build/project'
require 'motion_build/rules'

describe MotionBuild::Rules::ParseLLVMBitcodeRule do
  before :each do
    @project = MotionBuild::Project.new("Hello World")
    @project.config.override(:source_dir, Dir.mktmpdir)
    @project.config.override(:build_dir, Dir.mktmpdir)

    @r = MotionBuild::Rules::ParseLLVMBitcodeRule.new(@project, File.join(@project.config.get(:source_dir), 'test.bc'), arch: 'i386')
  end

  it "should input '.bc' files and output '.s' files" do
    @r.input_extension.should == '.bc'
    @r.output_extension.should == '.s'
  end

  it "should map arch to llc arch" do
    r = MotionBuild::Rules::ParseLLVMBitcodeRule.new(@project, File.join(@project.config.get(:source_dir), 'test.bc'), arch: 'i386')
    r.send(:llc_arch).should == 'x86'
    r = MotionBuild::Rules::ParseLLVMBitcodeRule.new(@project, File.join(@project.config.get(:source_dir), 'test.bc'), arch: 'x86_64')
    r.send(:llc_arch).should == 'x86-64'
    r = MotionBuild::Rules::ParseLLVMBitcodeRule.new(@project, File.join(@project.config.get(:source_dir), 'test.bc'), arch: 'armv6')
    r.send(:llc_arch).should == 'arm'
    r = MotionBuild::Rules::ParseLLVMBitcodeRule.new(@project, File.join(@project.config.get(:source_dir), 'test.bc'), arch: 'armv7')
    r.send(:llc_arch).should == 'arm'
  end

  it "should invoke llc binary with correct arguments" do
    @project.builder = builder_mock
    @project.builder.should_receive(:run).with('llc', [
      File.join(@project.config.get(:source_dir), 'test.bc'),
      "-o=#{File.join(@project.config.get(:build_dir_objects), 'test.i386.s')}",
      '-march=x86',
      '-relocation-model=pic',
      '-disable-fp-elim',
      '-jit-enable-eh',
      '-disable-cfi'])
    @r.action
  end

  after :each do
    FileUtils.remove_dir @project.config.get(:source_dir)
    FileUtils.remove_dir @project.config.get(:build_dir)
  end
end
