require 'motion_build/project'
require 'motion_build/rules'

describe Motion::Build::Rules::AssembleSourceRule do
  before :each do
    @project = Motion::Build::Project.new("Hello World")
    @project.config[:source_dir] = Dir.mktmpdir
    @project.config[:build_dir] = Dir.mktmpdir

    @r = Motion::Build::Rules::AssembleSourceRule.new(@project, File.join(@project.config[:source_dir], 'test.s'), arch: 'i386')
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
      File.join(@project.config[:source_dir], 'test.s'),
      '-o',
      File.join(@project.config[:build_dir], 'test.o')])
    @r.action
  end

  after :each do
    FileUtils.remove_dir @project.config[:source_dir]
    FileUtils.remove_dir @project.config[:build_dir]
  end
end
