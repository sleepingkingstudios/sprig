require 'spec_helper'

RSpec.describe "Seeding an application" do
  context "from a specific environment", :type => :integration do
    around do |example|
      stub_rails_env 'staging'
      load_seeds('posts.yml', &example)
    end

    it "seeds the db" do
      sprig [Post]

      Post.count.should == 1
      Post.pluck(:title).should =~ ['Staging yaml title']
    end
  end
end
