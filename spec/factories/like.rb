FactoryBot.define do
	factory :like do
		reaction { 'crab' }
		user
		post
	end
end