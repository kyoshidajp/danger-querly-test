require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerQuerly do
    it "should be a plugin" do
      expect(Danger::DangerQuerly.new(nil)).to be_a Danger::Plugin
    end

    describe "with Dangerfile" do
      before do
        @querly = testing_dangerfile.querly
      end
    end
  end
end
