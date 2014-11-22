require 'spec_helper'

RSpec.describe "Seeding an application" do
  context "with missing seed files", :type => :integration do
    it "raises a missing file error" do
      expect {
        sprig [Post]
      }.to raise_error(Sprig::Source::SourceDeterminer::FileNotFoundError)
    end
  end
end
