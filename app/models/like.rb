class Like < ApplicationRecord
	enum reaction: [:happy, :sad, :neutral, :crab, :glacier, :microphone, :obelisk, :shield]

	validates :post_id, uniqueness: { scope: :user_id, message: "already liked" }

	belongs_to :post
	belongs_to :user
end
