require 'motion_build/project'
require 'motion_build/rules'

describe MotionBuild::Rules::LipoRule do
  before :each do
    @project = MotionBuild::Project.new("Hello World")
    @project.config.override(:source_dir, Dir.mktmpdir)
    @project.config.override(:build_dir, Dir.mktmpdir)

    @r = MotionBuild::Rules::LipoRule.new(@project, [
      File.join(@project.config.get(:source_dir), 'test.i386.o'),
      File.join(@project.config.get(:source_dir), 'test.arm7.o'),
    ], File.join(@project.config.get(:build_dir_objects), 'test.o'))
  end

  it "should input '.o' files and output '.o' files" do
    @r.input_extension.should == '.o'
    @r.output_extension.should == '.o'
  end

  it "should invoke lipo binary with correct arguments" do
    @project.builder = builder_mock
    @project.builder.should_receive(:run).with('lipo', [
      '-create',
      File.join(@project.config.get(:source_dir), 'test.i386.o'),
      File.join(@project.config.get(:source_dir), 'test.arm7.o'),
      '-output',
      File.join(@project.config.get(:build_dir_objects), 'test.o')])
    @r.action
  end

  it "should be active if any of the source files is older" do
    Dir.mkdir @project.config.get(:build_dir_objects)
    FileUtils.touch File.join(@project.config.get(:source_dir), 'test.i386.o'),   mtime: Time.now - 50
    FileUtils.touch File.join(@project.config.get(:source_dir), 'test.arm7.o'),   mtime: Time.now - 150
    FileUtils.touch File.join(@project.config.get(:build_dir_objects), 'test.o'), mtime: Time.now - 100

    @r.should be_active
  end

  after :each do
    FileUtils.remove_dir @project.config.get(:source_dir)
    FileUtils.remove_dir @project.config.get(:build_dir)
  end
end
