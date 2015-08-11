require_relative '../loltest.rb'
require 'spec_helper'

describe LolObserver do
  subject {LolObserver.new("euw")}
  context "intialization" do
    it "require an apikey" do
      expect{LolObserver.new}.to raise_error(ArgumentError)
    end
    it "should assign the base_uri" do
      subject.class.base_ui.should eq("https://euw.api.pvp.net")
    end
    it "expect it's region to be EUW1" do
      subject.region.should == "EUW1"
    end
  end
  context "API down" do
    it "should raise a timeout error" do
      #todo
    end
  end
  context "200 API Response" do
    it "should return an array" do
      expect(subject.current_game_info).to be_a(Array)
    end
    it "should return an Array"
    it "should have the player id"
  end
end
