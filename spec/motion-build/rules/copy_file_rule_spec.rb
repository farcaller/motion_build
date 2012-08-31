require 'motion_build/project'
require 'motion_build/rules'

describe MotionBuild::Rules::CopyFileRule do
  before :each do
    @project = MotionBuild::Project.new("Hello World")
    @project.config.override(:source_dir, Dir.mktmpdir)
    @project.config.override(:build_dir, Dir.mktmpdir)

    @r = MotionBuild::Rules::CopyFileRule.new(@project, 'hello', 'world')
  end

  it "should invoke cp binary with correct arguments" do
    @project.builder = builder_mock
    @project.builder.should_receive(:run).with('cp', ['hello', 'world'])
    @r.action
  end

  after :each do
    FileUtils.remove_dir @project.config.get(:source_dir)
    FileUtils.remove_dir @project.config.get(:build_dir)
  end
end
