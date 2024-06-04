FactoryBot.define do
  factory :pub_follower do
    follower { "example_follower" }
    actor_url { "https://example.test/users/example_follower" }
  end
end
