require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create :user }
  let!(:post) { create :post, user_id: user.id }

  context 'liked_by' do
    it 'returns false if the post has not been liked' do
      post = Post.liked_by(user.id).first

      expect(post.crab_liked).to be false
      expect(post.microphone_liked).to be false
      expect(post.obelisk_liked).to be false
    end

    it 'returns true if the post has been liked' do
      create :like, user_id: user.id, post_id: post.id, reaction: 'crab'
      create :like, user_id: user.id, post_id: post.id, reaction: 'microphone'
      create :like, user_id: user.id, post_id: post.id, reaction: 'obelisk'

      post = Post.liked_by(user.id).first

      expect(post.crab_liked).to be true
      expect(post.microphone_liked).to be true
      expect(post.obelisk_liked).to be true
    end
  end

  context 'with_like_counts' do
    it 'returns 0 likes' do
      post = Post.with_like_counts.first

      expect(post.crab_count).to eql 0
      expect(post.microphone_count).to eql 0
      expect(post.obelisk_count).to eql 0
    end

    it 'returns the correct number likes' do
      create :like, user_id: user.id, post_id: post.id, reaction: 'crab'
      create :like, user_id: user.id, post_id: post.id, reaction: 'microphone'
      create :like, user_id: user.id, post_id: post.id, reaction: 'obelisk'

      post = Post.with_like_counts.first

      expect(post.crab_count).to eql 1
      expect(post.microphone_count).to eql 1
      expect(post.obelisk_count).to eql 1
    end

    context('with_likes') do
      it 'combines the above' do
        create :like, user_id: user.id, post_id: post.id, reaction: 'crab'

        post = Post.with_likes(user.id).first
        expect(post.crab_liked).to be true
        expect(post.crab_count).to eql 1

        expect(post.obelisk_liked).to be false
        expect(post.obelisk_count).to be 0
      end
    end
  end
end