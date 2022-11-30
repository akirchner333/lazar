module Pub
	class ActorController < ApplicationController
		skip_before_action :verify_authenticity_token

		# I'd like to add some feature posts (probably the 4-5 most recent posts)
		# And some boxes
		def actor
			summary = <<~HTML
			<p>
				Lazar dot social is a series of experiments into new forms of social media. 
				Any and all posts made on lazar will appear on this account.
			</p>
			HTML

			render :json => {
				"@context" => [
					"https://www.w3.org/ns/activitystreams",
					"https://w3id.org/security/v1"
				],
				id: "https://#{ENV['URL']}/pub/actor/#{params[:id]}",
				type: "Application",
				preferredUsername: "+lazar+",
				inbox: "https://#{ENV['URL']}/inbox",
				summary: summary,
				url: "https://lazar.social",
				publicKey: {
					id: "https://#{ENV['URL']}/actor#main-key",
					owner: "https://#{ENV['URL']}/actor",
					publicKeyPem: "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6EfbjygN0GF4pt4T09am\nv/cHt39xXNd0CRPA4f9uuX7iGqvNiq3OuGm3HUIDbUGhLQ3iid6v4A8EUu+ws7bD\nbnVdUtYr8MZT3qQC6ryvR42hvj1dNDPTkbQ+9f/BLeLKT7ux4abvusZld0TcMvCO\niC7av7PXQQ6bYS1MwJIBP4cfd+zi2jaKeGyStnWIdXHiFj1TYuC81BvgauW3SEdx\nZY3MSPYAGBTOAMrE81t+KJnBgVZkP9G/c+2LrPozkL9Xbov6O9xTCJtlknnCeIw1\npWTCb6Tl2FytrnvnkT9EWWRWV4RJDBxRaJWPOx7f6N5aQWCz/gbUyHDb2ZEnTzzM\niwIDAQAB\n-----END PUBLIC KEY-----"
				},
				icon: {
					type: "Image",
					mediaType: "image/png",
					url: "https://#{ENV['URL']}#{ActionController::Base.helpers.asset_path('lazar_icon.png')}"
				}
			}
		end

		def reply
			rfc_date = Time.now.utc.strftime('%FT%TZ')
			activity = {
			    "@context" => "https://www.w3.org/ns/activitystreams",
			    id: "#{ENV['url']}/create-hello-world",
			    type: "Create",
			    actor: "https://#{ENV['url']}/actor",
			    object: {
			        id: "https://#{ENV['url']}/hello-world",
			        type: "Note",
			        published: rfc_date,
			        attributedTo: "https://#{ENV['url']}/actor",
			        inReplyTo: "https://mastodon.social/@an_alexa_k/109334295008358033",
			        content: "<p>Hello World</p>",
			        to: "https://www.w3.org/ns/activitystreams#Public"
			    } 
			}
			document = JSON.generate(activity)

			response = HTTP.headers(http_signature('mastodon.social'))
					       .post('https://mastodon.social/inbox', body: document)

			p response

			render response
		end

		def inbox
			# TODO
		end
	end
end