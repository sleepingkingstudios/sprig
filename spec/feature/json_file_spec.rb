require 'spec_helper'

RSpec.describe "Seeding an application" do
  describe "with a json file", :type => :integration do
    around do |example|
      load_seeds('posts.json', &example)
    end

    it "seeds the db" do
      sprig [Post]

      Post.count.should == 1
      Post.pluck(:title).should =~ ['Json title']
    end
  end
end
