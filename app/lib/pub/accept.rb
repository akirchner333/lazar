module Pub
	class Accept < BaseObject
		Type = "Accept"

		def initialize(follower, object)
			@follower = follower
			@object = object
		end

		def id
			"#{full_url}/pub/actor/lazar#accepts/follows/#{@follower.id}"
		end

		def to_h
			{
				**super,
			    actor: "#{full_url}/pub/actor/lazar",
			    object: @object,
			}
		end
	end
end