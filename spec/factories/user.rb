FactoryBot.define do
	factory :user do
		username { 'test' }
		email { 'test@test.com' }
		password { SecureRandom.hex }
	end
end