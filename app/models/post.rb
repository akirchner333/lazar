include Gem::Text

class Post < ApplicationRecord
	belongs_to :user
	# default_scope { order(:words)}
	
	has_many :replies, class_name: "Post", foreign_key: 'posts_id'
	belongs_to :ply, class_name: "Post", foreign_key: 'posts_id', optional: true

	has_many :likes

	validates :words, length: { minimum: 4, maximum: 241 }
	validates_each :words do |record, attr, value|
		parent = Post.find(record.posts_id)
		distance = levenshtein_distance(parent.words, value)
		if record.posts_id && distance > 15
			record.errors.add(
				attr,
				"has a variance rating of #{distance} and must be 15 or less"
			)
		end
	end

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
end
