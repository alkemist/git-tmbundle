require File.dirname(__FILE__) + '/../../spec_helper'

describe SCM::Git::Remote do
  before(:each) do
    @git = Git.new
    Git.reset_mock!
  end
  
  include SpecHelpers
  
  it "should return a list of remote names" do
    Git.command_response["remote"] = "github\norigin"
    @git.remote.names.should == ["github", "origin"]
  end
  
  it "should return an Array of RemoteProxy objects" do
    Git.command_response["remote"] = "origin"
    remotes = @git.remote.all
    remotes.should have(1).item
    remotes.first.should be_kind_of(Git::Remote::RemoteProxy)
    remotes.first.name.should == "origin"
  end
  
  it "should retrieve a fetch refspec" do
    refspec = "+refs/heads/*:refs/remotes/origin/*"
    @git.config.should_receive(:[]).with("remote.origin.fetch").and_return("+refs/heads/*:refs/remotes/origin/*")
    @git.remote["origin"].fetch_refspec.should == refspec
  end
end
