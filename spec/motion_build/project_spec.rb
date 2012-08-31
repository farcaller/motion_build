require 'motion_build/project'

describe MotionBuild::Project do
  it "should have a name" do
    p = MotionBuild::Project.new("Hello World")
    p.name.should == "Hello World"
  end

  it "should have no sources" do
    p = MotionBuild::Project.new("Hello World")
    p.sources.count.should == 0
  end
end
