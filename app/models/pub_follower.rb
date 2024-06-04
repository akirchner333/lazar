class PubFollower < ApplicationRecord

	# {
	# 	"@context":"https://www.w3.org/ns/activitystreams",
	# 	"id":"https://activitypub.academy/9f1fc955-6251-4fe0-8bd9-b56b82486c4a",
	# 	"type":"Follow",
	# 	"actor":"https://activitypub.academy/users/dinulia_hondors",
	# 	"object":"https://instance.digital/users/an_alexa_k"
	# }
	def self.create_from_activity(params)
		# Sometimes it'll be a url and sometimes it'll be a hash?
		# Am I remembering that correctly?
		create(
			follower: params["actor"].split("/").last,
			actor_url: params["actor"],
			user_id: nil
		)
	end

	def inbox
		actor_url + "/inbox"
	end

	def host
		URI.parse(actor_url).host
	end

	# What should I do if the user gets deleted or moved?
	def full_actor
		response = HTTP.headers(
			'Content-Type' => 'application/activity+json',
			'Accept': 'application/activity+json'
		).get(actor_url)
		return false unless response.code == 200

		JSON.parse(response.to_s)
	end
end
