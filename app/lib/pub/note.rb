module Pub
	class Note < BaseObject
		Type = "Note"

		def initialize(post)
			@post = post
			@actor = "lazar"
		end

		def id
			"#{full_url}/posts/#{@post.id}.json"
		end

		def to_h
			content = "<p>#{@post.user.username.html_safe}: \"#{@post.words.html_safe}\"</p>"

			{
				**super,
				published: @post.created_at,
				summary: nil,
				url: "#{full_url}/posts/#{@post.id}",
				attributedTo:"#{full_url}/pub/actor/#{@actor}",
				to:[
					"https://www.w3.org/ns/activitystreams#Public"
				],
				cc:[
					"#{full_url}/pub/actor/#{@actor}/collections/followers"
				],
				sensitive: false,
				localOnly: false,
				content: content,
				contentMap: {
					en: content
				},
				attachment: [],
				tag: [],
				# inReplyTo: @post.parent_id ? "#{full_url}/posts/#{@post.parent_id}.json" : nil,
				inReplyTo: nil,
				# on Mastodon this links to a collection of replies. But see if direct links work
				# replies: @post.replies.pluck(:id).map { |id| "#{full_url}/posts/#{id}.json" }
				replies: []
				#atomUri: "...",
				#inReplyToAtomUri: nil,
				#conversation: "tag:#{ENV['url']},#{post.created_at}:objectId=#{post.id}:objectType=Conversation",
			}
		end
	end
end