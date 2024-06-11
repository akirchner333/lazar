module Pub
	class Create < BaseObject
		Type = "Create"

		def initialize(post)
			@post = post

			@actor = "lazar"
		end

		def id
			"#{full_url}/pub/activities/#{@post.id}"
		end

		def to_h
			date = Time.now.utc.httpdate
			{
				**super,
				actor:"#{full_url}/pub/actor/#{@actor}",
				published: date,
				to:[
					"https://www.w3.org/ns/activitystreams#Public"
				],
				cc:[
					"#{full_url}/pub/actor/#{@actor}/collections/followers"
				],
				object: @post.to_note.to_h,
				# signature: {
				# 	"type":"RsaSignature2017",
				# 	"creator":"https://#{ENV['URL']}/pub/actor/lazar#main-key",
				# 	"created": date,
				# 	"signatureValue":"????"
				# }
			}
		end
	end
end