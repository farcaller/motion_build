require 'motion-build/project'
require 'motion-build/rules'

describe Motion::Build::Rules::CopyFileRule do
  before :each do
    @project = Motion::Build::Project.new("Hello World")
    @project.config[:source_dir] = Dir.mktmpdir
    @project.config[:build_dir] = Dir.mktmpdir

    @r = Motion::Build::Rules::CopyFileRule.new(@project, 'hello', 'world')
  end

  it "should invoke cp binary with correct arguments" do
    @project.builder = builder_mock
    @project.builder.should_receive(:run).with('cp', ['hello', 'world'])
    @r.action
  end

  after :each do
    FileUtils.remove_dir @project.config[:source_dir]
    FileUtils.remove_dir @project.config[:build_dir]
  end
end
