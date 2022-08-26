FactoryBot.define do
	factory :post do
		words { 'test test test' }
		css { '' }
		generation { 6 }
		user
	end
end