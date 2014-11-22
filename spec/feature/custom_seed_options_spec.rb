require 'spec_helper'

RSpec.describe "Seeding an application" do
  let(:missing_record_error) do
    case Sprig.adapter
    when :active_record
      ActiveRecord::RecordNotFound
    when :mongoid
      Mongoid::Errors::DocumentNotFound
    else
      raise "unknown ORM/ODM #{Sprig.adapter.inspect}"
    end
  end

  context "with custom seed options", :type => :integration do
    context "using delete_existing_by" do
      around do |example|
        load_seeds('posts_delete_existing_by.yml', &example)
      end

      context "with an existing record" do
        let!(:existing_match) do
          Post.create(
            :title    => "Such Title",
            :content  => "Old Content")
        end

        let!(:existing_nonmatch) do
          Post.create(
            :title    => "Wow Title",
            :content  => "Much Content")
        end

        it "replaces only the matching existing record" do
          sprig [
            {
              :class  => Post,
              :source => open("spec/fixtures/seeds/test/posts_delete_existing_by.yml")
            }
          ]

          Post.count.should == 2

          expect {
            existing_match.reload
          }.to raise_error(missing_record_error)

          expect {
            existing_nonmatch.reload
          }.to_not raise_error
        end
      end
    end

    context "using find_existing_by" do
      context "with a missing attribute" do
        around do |example|
          load_seeds('posts_find_existing_by_missing.yml', &example)
        end

        it "raises a missing attribute error" do
          expect {
            sprig [
              {
                :class  => Post,
                :source => open("spec/fixtures/seeds/test/posts_find_existing_by_missing.yml")
              }
            ]
          }.to raise_error(Sprig::Seed::AttributeCollection::AttributeNotFoundError, "Attribute 'unicorn' is not present.")
        end
      end

      context "with a single attribute" do
        around do |example|
          load_seeds('posts.yml', 'posts_find_existing_by_single.yml', &example)
        end

        context "with an existing record" do
          let!(:existing) do
            Post.create(
              :title    => "Existing title",
              :content  => "Existing content")
          end

          it "updates the existing record" do
            sprig [
              {
                :class  => Post,
                :source => open("spec/fixtures/seeds/test/posts_find_existing_by_single.yml")
              }
            ]

            Post.count.should == 1
            existing.reload.content.should == "Updated content"
          end
        end
      end

      context "with multiple attributes" do
        around do |example|
          load_seeds('posts.yml', 'posts_find_existing_by_multiple.yml', &example)
        end

        context "with an existing record" do
          let!(:existing) do
            Post.create(
              :title      => "Existing title",
              :content    => "Existing content",
              :published  => false
            )
          end

          it "updates the existing record" do
            sprig [
              {
                :class  => Post,
                :source => open("spec/fixtures/seeds/test/posts_find_existing_by_multiple.yml")
              }
            ]

            Post.count.should == 1
            existing.reload.published.should == true
          end
        end
      end
    end
  end
end
