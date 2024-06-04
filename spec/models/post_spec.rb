require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create :user }
  let!(:post) do
    post = build :post, user_id: user.id, words: 'abc'
    post.save(validate: false)
    post
  end

  context 'distance' do
    it 'does not allow posts with too large a variance' do
      new_post = Post.new(words: 'abc1234567890123456', parent_id: post.id, user_id: user.id)
      expect(new_post.valid?).to be_falsey
      expect(new_post.errors.objects.first.full_message).to eq("Words have a variance rating of 16 and must be 15 or less.")
    end
  end

  context 'liked_by' do
    xit 'returns false if the post has not been liked' do
      post = Post.liked_by(user.id).first

      expect(post.crab_liked).to be false
      expect(post.microphone_liked).to be false
      expect(post.obelisk_liked).to be false
    end

    xit 'returns true if the post has been liked' do
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
    xit 'returns 0 likes' do
      post = Post.with_like_counts.first

      expect(post.crab_count).to eql 0
      expect(post.microphone_count).to eql 0
      expect(post.obelisk_count).to eql 0
    end

    xit 'returns the correct number likes' do
      create :like, user_id: user.id, post_id: post.id, reaction: 'crab'
      create :like, user_id: user.id, post_id: post.id, reaction: 'microphone'
      create :like, user_id: user.id, post_id: post.id, reaction: 'obelisk'

      post = Post.with_like_counts.first

      expect(post.crab_count).to eql 1
      expect(post.microphone_count).to eql 1
      expect(post.obelisk_count).to eql 1
    end
  end
end