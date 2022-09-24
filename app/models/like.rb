class Like < ApplicationRecord
	enum reaction: [:happy, :sad, :neutral, :crab, :glacier, :microphone, :obelisk, :shield]

	validates :post_id, uniqueness: { scope: %i[user_id reaction], message: "already liked" }

	belongs_to :post
	belongs_to :user
end
