require 'motion_build/project'
require 'motion_build/rules'

describe MotionBuild::Rules::CompileRubySourceRule do
  before :each do
    @project = MotionBuild::Project.new("Hello World")
    @project.config[:source_dir] = Dir.mktmpdir
    @project.config[:build_dir] = Dir.mktmpdir

    @r = MotionBuild::Rules::CompileRubySourceRule.new(@project, File.join(@project.config[:source_dir], 'test.rb'), archs: ['i386'], bridge_support_files: BRIDGE_SUPPORT_STUB)
  end

  it "should input '.rb' files and output '.o' files" do
    @r.input_extension.should == '.rb'
    @r.output_extension.should == '.o'
  end

  it "should set up the dependencies for one arch" do
    deps = <<EOF
<MotionBuild::Rules::CompileRubySourceRule [
  <MotionBuild::Rules::AssembleSourceRule [
    <MotionBuild::Rules::ParseLLVMBitcodeRule [
      <MotionBuild::Rules::EmitLLVMBitcodeRule>
    ]>
  ]>,
  <MotionBuild::Rules::CopyFileRule>
]>
EOF
    @r.inspect_dependencies.should == deps.strip
  end

  it "should set up the dependencies for multiple archs" do
    @r = MotionBuild::Rules::CompileRubySourceRule.new(@project, File.join(@project.config[:source_dir], 'test.rb'), archs: ['i386', 'armv7'], bridge_support_files: BRIDGE_SUPPORT_STUB)
    deps = <<EOF
<MotionBuild::Rules::CompileRubySourceRule [
  <MotionBuild::Rules::AssembleSourceRule [
    <MotionBuild::Rules::ParseLLVMBitcodeRule [
      <MotionBuild::Rules::EmitLLVMBitcodeRule>
    ]>
  ]>,
  <MotionBuild::Rules::AssembleSourceRule [
    <MotionBuild::Rules::ParseLLVMBitcodeRule [
      <MotionBuild::Rules::EmitLLVMBitcodeRule>
    ]>
  ]>,
  <MotionBuild::Rules::LipoRule>
]>
EOF
  @r.inspect_dependencies.should == deps.strip
  end

  after :each do
    FileUtils.remove_dir @project.config[:source_dir]
    FileUtils.remove_dir @project.config[:build_dir]
  end
end
