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
end
