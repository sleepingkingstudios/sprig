require 'spec_helper'

RSpec.describe "Seeding an application" do
  context "with files defined as attributes", :type => :integration do
    around do |example|
      load_seeds('posts_with_files.yml', &example)
    end

    it "seeds the db" do
      sprig [
        {
          :class  => Post,
          :source => open('spec/fixtures/seeds/test/posts_with_files.yml')
        }
      ]

      Post.count.should == 1
      Post.pluck(:photo).should =~ ['cat.png']
    end
  end
end
