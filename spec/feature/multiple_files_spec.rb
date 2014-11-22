require 'spec_helper'

RSpec.describe "Seeding an application" do
  context "with multiple files for a class", :type => :integration do
    around do |example|
      load_seeds('posts.yml', 'legacy_posts.yml', &example)
    end

    it "seeds the db" do
      sprig [
        Post,
        {
          :class  => Post,
          :source => open('spec/fixtures/seeds/test/legacy_posts.yml')
        }
      ]

      Post.count.should == 2
      Post.pluck(:title).should=~ ['Yaml title', 'Legacy yaml title']
    end
  end
end
