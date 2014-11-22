require 'spec_helper'

RSpec.describe "Seeding an application" do
  context "with multiple file relationships", :type => :integration do
    around do |example|
      load_seeds('posts.yml', 'comments.yml', &example)
    end

    it "seeds the db" do
      sprig [Post, Comment]

      Post.count.should    == 1
      Comment.count.should == 1
      Comment.first.post.should == Post.first
    end
  end

  context "with a relationship to an undefined record", :type => :integration do
    around do |example|
      load_seeds('posts.yml', 'posts_missing_dependency.yml', &example)
    end

    it "raises a helpful error message" do
      expect {
        sprig [
          {
            :class  => Post,
            :source => open('spec/fixtures/seeds/test/posts_missing_dependency.yml')
          }
        ]
      }.to raise_error(
        Sprig::DependencySorter::MissingDependencyError,
        "Undefined reference to 'sprig_record(Comment, 42)'"
      )
    end
  end

  context "with a relationship to a record that didn't save", :type => :integration do
    around do |example|
      load_seeds('invalid_users.yml', 'posts_missing_record.yml', &example)
    end

    it "does not error, but carries on with the seeding" do
      expect {
        sprig [
          {
            :class  => Post,
            :source => open('spec/fixtures/seeds/test/posts_missing_record.yml')
          },
          {
            :class  => User,
            :source => open('spec/fixtures/seeds/test/invalid_users.yml')
          }
        ]
      }.to_not raise_error
    end
  end

  context "with has_and_belongs_to_many relationships", :type => :integration do
    around do |example|
      load_seeds('posts_with_habtm.yml', 'tags.yml', &example)
    end

    it "saves the habtm relationships" do
      sprig [
        Tag,
        {
          :class  => Post,
          :source => open('spec/fixtures/seeds/test/posts_with_habtm.yml')
        }
      ]

      Post.first.tags.map(&:name).should == ['Botany', 'Biology']
    end
  end

  context "with cyclic dependencies", :type => :integration do
    around do |example|
      load_seeds('comments.yml', 'posts_with_cyclic_dependencies.yml', &example)
    end

    it "raises an cyclic dependency error" do
      expect {
        sprig [
          {
            :class  => Post,
            :source => open('spec/fixtures/seeds/test/posts_with_cyclic_dependencies.yml')
          },
          Comment
        ]
      }.to raise_error(Sprig::DependencySorter::CircularDependencyError)
    end
  end
end
