class Post < ApplicationRecord
	belongs_to :user
	# default_scope { order(:words)}
	
	has_and_belongs_to_many :plies,
		class_name: "Post", 
		join_table: :plies_replies,
		foreign_key: :ply_id,
		association_foreign_key: :reply_id
	has_and_belongs_to_many :replies,
		class_name: "Post", 
		join_table: :plies_replies,
		foreign_key: :reply_id,
		association_foreign_key: :ply_id
	has_many :likes

	validates :words, length: { minimum: 4, maximum: 142 }

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
