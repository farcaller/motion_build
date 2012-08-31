require 'motion_build/project'
require 'motion_build/rules'

describe MotionBuild::Rules::AssembleSourceRule do
  before :each do
    @project = MotionBuild::Project.new("Hello World")
    @project.config.override(:source_dir, Dir.mktmpdir)
    @project.config.override(:build_dir, Dir.mktmpdir)

    @r = MotionBuild::Rules::AssembleSourceRule.new(@project, File.join(@project.config.get(:source_dir), 'test.s'), arch: 'i386')
  end

  it "should input '.s' files and output '.o' files" do
    @r.input_extension.should == '.s'
    @r.output_extension.should == '.o'
  end

  it "should invoke gcc binary with correct arguments" do
    @project.builder = builder_mock
    @project.builder.should_receive(:run).with('gcc', [
      '-fexceptions',
      '-c',
      '-arch', 'i386',
      File.join(@project.config.get(:source_dir), 'test.s'),
      '-o',
      File.join(@project.config.get(:build_dir_objects), 'test.o')])
    @r.action
  end

  after :each do
    FileUtils.remove_dir @project.config.get(:source_dir)
    FileUtils.remove_dir @project.config.get(:build_dir)
  end
end
