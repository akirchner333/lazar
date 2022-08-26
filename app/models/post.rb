class Post < ApplicationRecord
	belongs_to :user
	
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


	def self.with_likes(user_id)
		with_like_counts.liked_by(user_id)
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
