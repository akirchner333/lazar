module Pub
	class InboxController < ApplicationController
		include ActivityPubHelper
		skip_before_action :verify_authenticity_token

		def inbox
			body = JSON.parse(request.raw_post)
			if helpers.sig_check(request.headers)
				p "Inbox Request #{body}"
				if body['type'] == "Follow" && body['object'].ends_with?('lazar')
					follower = PubFollower.create_from_activity(body)
					inbox = follower.inbox
					headers = helpers.http_signature(follower.host)
					accept_body = {
						'@context': [
							'https://www.w3.org/ns/activitystreams',
							'https://w3id.org/security/v1'
						],
					    id: "#{full_url}/pub/actor/lazar#accepts/follows/#{follower.id}",
					    type: 'Accept',
					    actor: "#{full_url}/pub/actor/lazar",
					    object: body,
					}
					HTTP.headers(headers).post(inbox, body: JSON.generate(accept_body))
				elsif body['type'] == "Undo"
					if body['object']['type'] == 'Follow'
						# Unfollow
						PubFollower.where(actor_url: body['actor']).delete_all
						# What should we send back?
					end
				end

				render plain: 'OK', status: 200
			else
				p "Invalid request to inbox"
				render plain: 'Request signature could not be verified', status: 401
			end
		end
	end
end