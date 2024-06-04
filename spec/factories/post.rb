FactoryBot.define do
	factory :post do
		words { 'test test test' }
		css { '' }
		generation { 7 }
		user
	end
end