module Pub
	class ActorController < ApplicationController
		include ActivityPubHelper

		skip_before_action :verify_authenticity_token

		# I'd like to add some feature posts (probably the 4-5 most recent posts)
		# And some boxes
		def actor
			summary = <<~HTML
			<p>
				Every post made by anyone on lazar.social, the home of a series of
				cutting edge social media experiments.
			</p>
			HTML

			render :json => {
				"@context" => [
					"https://www.w3.org/ns/activitystreams",
					"https://w3id.org/security/v1"
				],
				id: "#{full_url}/pub/actor/#{params[:id]}",
				type: "Application",
				# following: "",
				# followers: "",
				preferredUsername: "lazar",
				name: "Lazar Firehose",
				inbox: "#{full_url}/pub/inbox",
				# featured: "", <-- I'd like to do this. But it'll need another url
				# featuredTags: "",
				summary: summary,
				url: "https://lazar.social",
				manuallyApprovesFollowers: false,
				discoverable: true,
				published: "1937-01-01T00:00:00Z",
				publicKey: {
					id: "#{full_url}/pub/actor/lazar#main-key",
					owner: "#{full_url}/pub/actor/lazar#main-key",
					publicKeyPem: "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6EfbjygN0GF4pt4T09am\nv/cHt39xXNd0CRPA4f9uuX7iGqvNiq3OuGm3HUIDbUGhLQ3iid6v4A8EUu+ws7bD\nbnVdUtYr8MZT3qQC6ryvR42hvj1dNDPTkbQ+9f/BLeLKT7ux4abvusZld0TcMvCO\niC7av7PXQQ6bYS1MwJIBP4cfd+zi2jaKeGyStnWIdXHiFj1TYuC81BvgauW3SEdx\nZY3MSPYAGBTOAMrE81t+KJnBgVZkP9G/c+2LrPozkL9Xbov6O9xTCJtlknnCeIw1\npWTCb6Tl2FytrnvnkT9EWWRWV4RJDBxRaJWPOx7f6N5aQWCz/gbUyHDb2ZEnTzzM\niwIDAQAB\n-----END PUBLIC KEY-----"
				},
				icon: {
					type: "Image",
					mediaType: "image/png",
					url: "#{full_url}#{ActionController::Base.helpers.asset_path('lazar_icon.png')}"
				},
				# image: { //Put a header here
				# 	type: "Image",
				# 	mediaType: "image/png",
				# 	url: ""
				# },
				attachment: [
					{
						type: "PropertyValue",
						name: "Lazar is currently",
						value: ENV['SITE_LIVE'] == 'true' ? "awake" : "asleep"
					},{
						type: "PropertyValue",
						name: "Current Generation",
						value: "6"
					}
				]
			}
		end

		# def reply
		# 	rfc_date = Time.now.utc.strftime('%FT%TZ')
		# 	activity = {
		# 	    "@context" => "https://www.w3.org/ns/activitystreams",
		# 	    id: "#{ENV['url']}/create-hello-world",
		# 	    type: "Create",
		# 	    actor: "https://#{ENV['url']}/actor",
		# 	    object: {
		# 	        id: "https://#{ENV['url']}/hello-world",
		# 	        type: "Note",
		# 	        published: rfc_date,
		# 	        attributedTo: "https://#{ENV['url']}/actor",
		# 	        inReplyTo: "https://mastodon.social/@an_alexa_k/109334295008358033",
		# 	        content: "<p>Hello World</p>",
		# 	        to: "https://www.w3.org/ns/activitystreams#Public"
		# 	    } 
		# 	}
		# 	document = JSON.generate(activity)

		# 	response = HTTP.headers(http_signature('mastodon.social'))
		# 			       .post('https://mastodon.social/inbox', body: document)

		# 	p response

		# 	render response
		# end
	end
end