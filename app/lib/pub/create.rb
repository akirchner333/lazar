module Pub
	class Create < BaseObject
		Type = "Create"

		def initialize(post)
			@post = post

			@actor = "lazar"
		end

		def id
			# Currently this isn't hooked up to anything. Does it manner?
			"#{full_url}/pub/actors/#{@actor}/statuses/#{@post.id}/activity"
		end

		def to_h
			date = Time.now.utc.httpdate
			{
				**super,
				actor:"#{full_url}/pub/actors/#{@actor}",
				published: date,
				to:[
					"https://www.w3.org/ns/activitystreams#Public"
				],
				cc:[
					"#{full_url}/pub/actors/#{@actor}/collections/followers"
				],
				object: @post.to_note.to_h,
				signature: {
					"type":"RsaSignature2017",
					"creator":"https://#{ENV['URL']}/pub/actors/lazar#main-key",
					"created": date,
					"signatureValue":"????"
				}
			}
		end
	end
end