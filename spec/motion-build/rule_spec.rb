require 'motion-build/project'
require 'motion-build/rule'

class TestRule < Motion::Build::Rule
  attr_accessor :action_runs_count
  def run
    @action_runs_count = @action_runs_count ? @action_runs_count+1 : 1
  end
end

class TestActiveRule < TestRule
  def active?
    true
  end
end

describe Motion::Build::Rule do
  before :each do
    @project = Motion::Build::Project.new("Hello World")
  end

  it "should not run by default" do
    r = TestRule.new(@project)
    r.should_not be_active
    r.action
    r.action_runs_count.should be_nil
  end

  it "should have no dependencies" do
    r = Motion::Build::Rule.new(@project)
    r.dependencies.count.should == 0
  end

  it "should run when forced" do
    r = TestRule.new(@project)
    r.action!
    r.action_runs_count.should == 1
  end

  it "should run if action is available" do
    r = TestActiveRule.new(@project)
    r.action
    r.action_runs_count.should == 1
  end

  it "should run the dependency rules" do
    r = TestActiveRule.new(@project)
    dep = double("TestRule")
    dep.should_receive(:action).once
    r.dependencies << dep
    r.action
  end

  it "should force-run the dependency rules when forced" do
    r = TestActiveRule.new(@project)
    dep = double("TestRule")
    dep.should_receive(:action!).once
    r.dependencies << dep
    r.action!
  end
end
