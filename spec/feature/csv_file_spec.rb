require 'spec_helper'

RSpec.describe "Seeding an application" do
  describe "with a csv file", :type => :integration do
    around do |example|
      load_seeds('posts.csv', &example)
    end

    it "seeds the db" do
      sprig [Post]

      Post.count.should == 1
      Post.pluck(:title).should =~ ['Csv title']
    end
  end
end
