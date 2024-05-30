include Gem::Text

class Post < ApplicationRecord
	# ~~~~~ Associations ~~~~~~~~
	belongs_to :user
	
	has_many :replies, class_name: "Post", foreign_key: 'parent_id'
	belongs_to :ply, class_name: "Post", foreign_key: 'parent_id', optional: true

	belongs_to :root, class_name: "Post", foreign_key: 'root_id'

	has_many :likes

	# ~~~~~ Validations ~~~~~~~~
	validates :words, length: { minimum: 4, maximum: 241 }
	validates :words, uniqueness: {
		message: "have already been said."
	}
	validates_each :words do |record, attr, value|
		parent = Post.find(record.parent_id)
		distance = levenshtein_distance(parent.words, value)
		if record.parent_id && distance > 15
			record.errors.add(
				attr,
				"has a variance rating of #{distance} and must be 15 or less."
			)
		end
	end

	# ~~~~~ Callbacks ~~~~~~~~
	before_validation :set_root_and_distance

	def self.with_everything(user, params)
		scope = limit(30)
			.with_like_counts
			.sort_method(params[:order])
			.offset((params[:page].to_i || 0) * 30)

		if user
			scope.liked_by(user.id)
		else
			scope
		end

	end

	def self.with_like_counts
		left_joins(:likes)
		.select(
			'posts.*',
			like_counts_sql("crab"),
			like_counts_sql("microphone"),
			like_counts_sql("obelisk")
		)
		.group('posts.id')
	end

	def self.liked_by(user_id)
		left_joins(:likes)
		.select(
			'posts.*',
			liked_by_sql(user_id, "crab"),
			liked_by_sql(user_id, "microphone"),
			liked_by_sql(user_id, "obelisk")
		)
		.group('posts.id')
	end

	def self.sort_method(param)
		case param
		when 'alpha'
			order(:words)
		when 'revalpha'
			order(words: :desc)
		when 'chrono'
			order(:created_at)
		when 'revchrono'
			order(created_at: :desc)
		else
			order(:words)
		end

		# What else? Like count? plies/replies? Some other fucked up attributes?
		# This is probably enough for now
	end

	def to_note(full_url)
		{
			"@context" => "https://www.w3.org/ns/activitystreams",
			type: "Note",
			id: "#{full_url}/posts/#{id}",
			summary: nil,
			# Could link to the parent
			inReplyTo: nil,
			published: created_at,
			url: "#{full_url}/posts/#{id}",
			to: [],
			cc: [],
			sensitive: false,
			#atomUri: "...",
			#inReplyToAtomUri: nil,
			# conversation: "tag:#{ENV['url']},#{post.created_at}:objectId=#{post.id}:objectType=Conversation",
			content: "<p>#{words.html_safe}</p>",
			contentMap: {
				en: "<p>#{words.html_safe}</p>"
			},
			attachment: [],
			tag: [],
			# Could set up something here to link all the posts together
			replies: []
		}
	end

	private

	# These should be sanitized somewhat
	def self.like_counts_sql(reaction)
		<<~SQL
			COUNT(
				CASE
					WHEN
						likes.reaction = #{Like.reactions[reaction]}
					THEN 1
					ELSE null
				END
			) AS #{reaction}_count
		SQL
	end

	def self.liked_by_sql(user_id, reaction)
		<<~SQL
			COUNT(
				CASE 
					WHEN
						likes.user_id = #{user_id} AND likes.reaction = #{Like.reactions[reaction]} 
					THEN 1 
					ELSE null 
				END
			) > 0 AS #{reaction}_liked
		SQL
	end

	def set_root_and_distance
		parent = Post.find(self.parent_id)
		self.root_id = parent.root_id || self.parent_id
		root = Post.find(self.root_id)
		self.distance = levenshtein_distance(root.words, self.words)
	end
end
