class LikesController < ApplicationController
	before_action :find_post, only: %i[create destroy]

	def create
		@post.likes.create(user_id: Current.user.id, reaction: params[:reaction])

		respond_to do |format|
			p format
			format.html { redirect_to @post }
			format.json { head :no_content }
			format.js { }
		end
	end

	def destroy
		Like
			.where(user_id: Current.user.id, post_id: @post.id, reaction: params["reaction"])
			.delete_all

		respond_to do |format|
			format.html { redirect_to @post }
			format.json { head :no_content }
			format.js { }
		end
	end

	def user_index
		p "Starting the old likes cotnroller!"
		if turbo_frame_request?
			p "I know this a turbo frame"
		else
			p "I don't think this is a frame"
		end
		# @likes = Post
		# 	.with_likes(Current.user.id)
		# 	.where('likes.reaction' => params["reaction"], 'likes.user_id' => Current.user.id)
	end

	def index
		@likes = Post
			.with_likes(Current.user.id)
			.where('likes.reaction' => params["reaction"], 'likes.user_id' => params["user"])
	end

	private
	def like_params
		params.require(:like).permit(:post_id, :reaction)
	end

	def find_post
		@post = Post.find(params[:post_id])
	end
end
