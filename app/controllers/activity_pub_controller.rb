require 'http'
require 'openssl'

class ActivityPubController < ApplicationController
	def webfinger
		render :json => {
			subject: "acct:lazar@#{ENV['URL']}",
			links: [
				{
					rel: "self",
					type: "application/activity+json",
					href: "#{ENV['URL']}/actor"
				}
			]
		}
	end

	def actor
		render :json => {
			"@context" => [
				"https://www.w3.org/ns/activitystreams",
				"https://w3id.org/security/v1"
			],
			id: "#{ENV['URL']}/actor",
			type: "Person",
			preferredUsername: "LAZAR",
			inbox: "#{ENV['URL']}/inbox",
			publicKey: {
				id: "#{ENV['URL']}/actor#main-key",
				owner: "#{ENV['URL']}/actor",
				publicKeyPem: "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6EfbjygN0GF4pt4T09am\nv/cHt39xXNd0CRPA4f9uuX7iGqvNiq3OuGm3HUIDbUGhLQ3iid6v4A8EUu+ws7bD\nbnVdUtYr8MZT3qQC6ryvR42hvj1dNDPTkbQ+9f/BLeLKT7ux4abvusZld0TcMvCO\niC7av7PXQQ6bYS1MwJIBP4cfd+zi2jaKeGyStnWIdXHiFj1TYuC81BvgauW3SEdx\nZY3MSPYAGBTOAMrE81t+KJnBgVZkP9G/c+2LrPozkL9Xbov6O9xTCJtlknnCeIw1\npWTCb6Tl2FytrnvnkT9EWWRWV4RJDBxRaJWPOx7f6N5aQWCz/gbUyHDb2ZEnTzzM\niwIDAQAB\n-----END PUBLIC KEY-----"
			}
		}
	end

	def reply
		rfc_date = Time.now.utc.strftime('%FT%TZ')
		activity = {
		    "@context" => "https://www.w3.org/ns/activitystreams",
		    id: "#{ENV['url']}/create-hello-world",
		    type: "Create",
		    actor: "#{ENV['url']}/actor",
		    object: {
		        id: "#{ENV['url']}/hello-world",
		        type: "Note",
		        published: rfc_date,
		        attributedTo: "#{ENV['url']}/actor",
		        inReplyTo: "https://mastodon.social/@an_alexa_k/109334295008358033",
		        content: "<p>Hello World</p>",
		        to: "https://www.w3.org/ns/activitystreams#Public"
		    } 
		}
		document = JSON.generate(activity)

		date          = Time.now.utc.httpdate
		keypair       = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'])
		signed_string = "(request-target): post /inbox\nhost: mastodon.social\ndate: #{date}"
		signature     = Base64.strict_encode64(keypair.sign(OpenSSL::Digest::SHA256.new, signed_string))
		header        = "keyId=\"#{}/actor\",headers=\"(request-target) host date\",signature=\"#{signature}\""

		response = HTTP.headers({ 'Host': 'mastodon.social', 'Date': date, 'Signature': header })
				    .post('https://mastodon.social/inbox', body: document)

		
	end

	def inbox
		# TODO
	end
end
