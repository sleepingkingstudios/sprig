require 'spec_helper'

RSpec.describe "Seeding an application" do
  describe "with a yaml file", :type => :integration do
    around do |example|
      load_seeds('posts_and_comments.yml', &example)
    end

    it "seeds the db" do
      sprig [
        {
          :class  => Post,
          :source => open('spec/fixtures/seeds/test/posts_and_comments.yml')
        }
      ]

      post, comment = Post.first, Comment.first

      expect(Post.count).to be == 1
      expect(Comment.count).to be == 1

      expect(post.title).to be == 'Yaml title'
      expect(comment.body).to be == 'Comment body'
      expect(comment.post_id).to be == post.id
    end
  end
end
