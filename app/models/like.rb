class Like < ApplicationRecord
	enum reaction: [:happy, :sad, :neutral, :crab, :glacier, :microphone, :obelisk, :shield]

	belongs_to :post
	belongs_to :user
end
