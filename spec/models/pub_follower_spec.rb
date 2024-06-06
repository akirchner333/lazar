require 'rails_helper'

RSpec.describe PubFollower, type: :model do
  let(:follower) { create :pub_follower }

  it 'creates a new pub follower from a follow request' do
    body = JSON.parse('{
      "@context":"https://www.w3.org/ns/activitystreams",
      "id":"https://example.test/9f1fc955-6251-4fe0-8bd9-b56b82486c4a",
      "type":"Follow",
      "actor":"https://example.test/users/example_follower",
      "object":"https://lazar.social/users/lazar"
    }')

    follower = PubFollower.create_from_activity(body)
    expect(follower.follower).to eq("example_follower")
    expect(follower.actor_url).to eq("https://example.test/users/example_follower")
  end

  it 'does not create a follower if they already exist' do
    body = JSON.parse('{
      "@context":"https://www.w3.org/ns/activitystreams",
      "id":"https://example.test/9f1fc955-6251-4fe0-8bd9-b56b82486c4a",
      "type":"Follow",
      "actor":"https://example.test/users/example_follower",
      "object":"https://lazar.social/users/lazar"
    }')

    PubFollower.create_from_activity(body)
    expect(PubFollower.count).to equal(1)

    PubFollower.create_from_activity(body)
    expect(PubFollower.count).to equal(1)
  end

  it 'provides the inbox url' do
    expect(follower.inbox).to eq("https://example.test/users/example_follower/inbox")
  end

  it 'provides the host' do
    expect(follower.host).to eq("example.test")
  end

  it 'has an id' do
    expect(follower).to have_attribute(:id)
  end

  it 'provides a list of all inboxes' do
    create :pub_follower, actor_url: "https://example.test/users/follower1"
    create :pub_follower, actor_url: "https://example.test/users/follower2"
    create :pub_follower, actor_url: "https://example2.test/users/follower3"

    inboxes = PubFollower.shared_inboxes
    expect(inboxes).to contain_exactly("https://example.test/inbox", "https://example2.test/inbox")
  end
end
