require 'spec_helper'

RSpec.describe "Seeding an application" do
  describe "with a custom source", :type => :integration do
    around do |example|
      load_seeds('legacy_posts.yml', &example)
    end

    it "seeds" do
      sprig [
        {
          :class  => Post,
          :source => open('spec/fixtures/seeds/test/legacy_posts.yml')
        }
      ]

      Post.count.should == 1
      Post.pluck(:title).should =~ ['Legacy yaml title']
    end
  end

  context "with an invalid custom source", :type => :integration do
    it "fails with an argument error" do
      expect {
        sprig [ { :class => Post, :source => 42 } ]
      }.to raise_error(ArgumentError, 'Data sources must act like an IO.')
    end
  end

  context "with a custom source that cannot be parsed by native parsers", :type => :integration do
    around do |example|
      load_seeds('posts.md', &example)
    end

    it "fails with an unparsable file error" do
      expect {
        sprig [
          {
            :class  => Post,
            :source => open('spec/fixtures/seeds/test/posts.md')
          }
        ]
      }.to raise_error(Sprig::Source::ParserDeterminer::UnparsableFileError)
    end
  end
end
