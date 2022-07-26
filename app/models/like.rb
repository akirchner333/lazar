class Like < ApplicationRecord
	enum reaction: [:happy, :sad, :neutral, :crab, :glacier, :microphone, :obelisk, :shield]
end
