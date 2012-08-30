require 'motion-build/project'

describe Motion::Build::Project do
  it "should have a name" do
    p = Motion::Build::Project.new("Hello World")
    p.name.should == "Hello World"
  end

  it "should have no sources" do
    p = Motion::Build::Project.new("Hello World")
    p.sources.count.should == 0
  end
end
