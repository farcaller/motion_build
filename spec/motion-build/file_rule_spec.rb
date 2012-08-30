require 'motion_build/project'
require 'motion_build/file_rule'
require 'tmpdir'

class TestFileRule < MotionBuild::FileRule
  def input_extension; '.src'; end
  def output_extension; '.dst'; end
end

class NoDestTestFileRule < MotionBuild::FileRule
  def input_extension; '.src'; end
end

describe MotionBuild::FileRule do
  before :each do
    @project = MotionBuild::Project.new("Hello World")
  end

  it "should have input and output extensions" do
    r = TestFileRule.new(@project)
    r.input_extension.should == '.src'
    r.output_extension.should == '.dst'
  end

  it "should accept one input file" do
    expect { TestFileRule.new(@project, 'input.src') }.to_not raise_error(ArgumentError)

    TestFileRule.new(@project, 'input.src').source.should == 'input.src'
  end

  it "should not accept an input file with bad extension" do
    expect { TestFileRule.new(@project, 'input.bad') }.to raise_error(ArgumentError)
  end

  it "should accept any file if no extension is defined" do
    expect { MotionBuild::FileRule.new(@project, 'input.bad') }.to_not raise_error(ArgumentError)
  end

  it "should not accept more than one argument" do
    expect { MotionBuild::FileRule.new(@project, 'input.bad', 'trash') }.to raise_error(ArgumentError)
  end

  it "should have empty destination by default" do
    MotionBuild::FileRule.new(@project, 'input.bad').destination.should be_nil
  end

  it "should resolve project-relative path for source" do
    @project.config[:source_dir] = '/var/tmp/nowhere/'
    r = MotionBuild::FileRule.new(@project, '/var/tmp/nowhere/subdir/input.src')
    r.send(:relative_source).should == 'subdir/input.src'
  end

  it "should resolve destination-relative path for known extension" do
    @project.config[:source_dir] = '/var/tmp/nowhere/'
    @project.config[:build_dir] = '/var/tmp/nowhere/build/'
    r = TestFileRule.new(@project, '/var/tmp/nowhere/subdir/input.src')
    r.send(:relative_destination).should == 'subdir/input.dst'
  end

  it "should resolve destination path for known extension" do
    @project.config[:source_dir] = '/var/tmp/nowhere/'
    @project.config[:build_dir] = '/var/tmp/nowhere/build/'
    r = TestFileRule.new(@project, '/var/tmp/nowhere/subdir/input.src')
    r.destination.should == '/var/tmp/nowhere/build/subdir/input.dst'
  end

  it "should be active if there's no source file" do
    r = TestFileRule.new(@project)
    r.should be_active
  end

  context "with existing source and build dirs" do
    before :each do
      @project.config[:source_dir] = Dir.mktmpdir
      @project.config[:build_dir] = Dir.mktmpdir
    end

    it "should be active if there's no destination extension" do
      r = NoDestTestFileRule.new(@project, 'test.src')
      r.should be_active
    end

    it "should be active if there's no destination file" do
      FileUtils.touch File.join(@project.config[:source_dir], 'test.src')
      r = TestFileRule.new(@project, File.join(@project.config[:source_dir], 'test.src'))
      r.should be_active
    end

    it "should be active if the source file is older than destination file" do
      FileUtils.touch File.join(@project.config[:source_dir], 'test.src'), mtime: Time.now - 50
      FileUtils.touch File.join(@project.config[:build_dir], 'test.dst'), mtime: Time.now - 100

      r = TestFileRule.new(@project, File.join(@project.config[:source_dir], 'test.src'))
      r.should be_active
    end

    it "should be inactive otherwise" do
      FileUtils.touch File.join(@project.config[:source_dir], 'test.src'), mtime: Time.now - 100
      FileUtils.touch File.join(@project.config[:build_dir], 'test.dst'), mtime: Time.now - 50

      r = TestFileRule.new(@project, File.join(@project.config[:source_dir], 'test.src'))
      r.should_not be_active
    end

    it "creates destination directory" do
      r = TestFileRule.new(@project, File.join(@project.config[:source_dir], 'test', 'test.src'))
      r.send(:ensure_destination_directory)
      d = File.join(@project.config[:build_dir], 'test')
      File.should be_directory(d)
    end

    after :each do
      FileUtils.remove_dir @project.config[:source_dir]
      FileUtils.remove_dir @project.config[:build_dir]
    end
  end
end
