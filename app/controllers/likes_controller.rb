class LikesController < ApplicationController
	def create
		# make a like...
	end

	def user_index
		@likes = Post
			.joins(:likes)
			.where('likes.reaction' => params["reaction"], 'likes.user_id' => Current.user.id)
	end

	def index
		@likes = Post
			.joins(:likes)
			.where('likes.reaction' => params["reaction"], 'likes.user_id' => params["user"])
	end
end
