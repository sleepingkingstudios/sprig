require 'spec_helper'

RSpec.describe "Seeding an application" do
  describe "with a google spreadsheet", :type => :integration do
    it "seeds the db", :vcr => { :cassette_name => 'google_spreadsheet_json_posts' } do
      sprig [
        {
          :class  => Post,
          :parser => Sprig::Parser::GoogleSpreadsheetJson,
          :source => open('https://spreadsheets.google.com/feeds/list/0AjVLPMnHm86rdDVHQ2dCUS03RTN5ZUtVNzVOYVBwT0E/1/public/values?alt=json'),
        }
      ]

      Post.count.should == 1
      Post.pluck(:title).should =~ ['Google spreadsheet json title']
    end
  end

  describe "with an invalid custom parser", :type => :integration do
    around do |example|
      load_seeds('posts.yml', &example)
    end

    it "fails with an argument error" do
      expect {
        sprig [
          {
            :class  => Post,
            :source => open('spec/fixtures/seeds/test/posts.yml'),
            :parser => Object # Not a valid parser
          }
        ]
      }.to raise_error(ArgumentError, 'Parsers must define #parse.')
    end
  end
end
