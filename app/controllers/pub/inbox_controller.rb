module Pub
	class InboxController < ApplicationController
		include ActivityPubHelper
		skip_before_action :verify_authenticity_token

		def inbox
			p "Inbox times! #{params}"
			if helpers.sig_check(request.headers)
				if params['type'] == "Follow"
					follower = PubFollower.create(actor_url: params['actor'])
					inbox = follower.full_actor['inbox']
					headers = helpers.http_signature(ENV['URL'])
					HTTP.headers(headers).post(inbox, body: {
						'@context': [
							'https://www.w3.org/ns/activitystreams',
							'https://w3id.org/security/v1'
						],
					    id: `https://${domain}/${guid}`,
					    type: 'Accept',
					    actor: "https://#{ENV['URL']}/pub/actor/lazar",
					    object: params,
					})
				elsif params['type'] == "Undo"
					if params['object']['type'] == 'Follow'
						# Unfollow
						PubFollower.where(account_url: params['actor']).delete_all
					end
				end

				render plain: 'OK', status: 200
			else
				render plain: 'Request signature could not be verified', status: 401
			end
		end

		def test
			document = JSON.generate({hello: "hello!"})

			headers = helpers.http_signature('localhost:3000')
			# p headers
			# response = HTTP.headers(headers)
			# 		       .post('http://localhost:3000/pub/inbox', body: document)

			# render plain: response.to_s, status: 200
			curl_headers = headers.to_a.map do |kv|
				"-H '#{kv[0]}: #{kv[1]}'"
			end.join(' ')
			render plain: "curl -X POST #{curl_headers} http://localhost:3000/pub/inbox\n" 
		end
	end
end