module Pub
	class InboxController < ApplicationController
		include ActivityPubHelper
		skip_before_action :verify_authenticity_token

		def inbox
			body = JSON.parse(request.raw_post)
			if helpers.sig_check(request.headers)
				if body['type'] == "Follow" && body['object'].ends_with?('lazar')
					follower = PubFollower.create(actor_url: body['actor'])
					inbox = follower.full_actor['inbox']
					headers = helpers.http_signature(ENV['URL'], target)
					HTTP.headers(headers).post(inbox, body: {
						'@context': [
							'https://www.w3.org/ns/activitystreams',
							'https://w3id.org/security/v1'
						],
					    id: `https://${domain}/${guid}`,
					    type: 'Accept',
					    actor: "https://#{ENV['URL']}/pub/actor/lazar",
					    object: body,
					})
				elsif body['type'] == "Undo"
					if body['object']['type'] == 'Follow'
						# Unfollow
						PubFollower.where(actor_url: body['actor']).delete_all
						# What should we send back?
					end
				end

				render plain: 'OK', status: 200
			else
				render plain: 'Request signature could not be verified', status: 401
			end
		end

		def inbox_test
			p "Somebody is posting to /inbox"
			p params
			p request.body
			p request.raw_post
			render plain: 'No', status: 404
		end
	end
end