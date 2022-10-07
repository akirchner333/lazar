class LikesController < ApplicationController
	before_action :find_post, only: %i[create destroy]

	def create
		like = @post.likes.create(user_id: Current.user.id, reaction: params[:reaction])

		render partial: 'like_button', locals: {
			post_id: @post.id,
			reaction: params[:reaction],
			count: @post.likes.where(reaction: params[:reaction]).count,
			liked: true
		}
	end

	def destroy
		Like
			.where(user_id: Current.user.id, post_id: @post.id, reaction: params["reaction"])
			.delete_all

		# render partial: 'like_button'

		render partial: 'like_button', locals: {
			post_id: @post.id,
			reaction: params[:reaction],
			count: @post.likes.where(reaction: params[:reaction]).count,
			liked: false
		}
	end

	def user_index
		@likes = Post
			.where('likes.reaction' => params["reaction"], 'likes.user_id' => Current.user.id)
			.with_everything(Current.user, params)
	end

	def index
		@likes = Post
			.where('likes.reaction' => params["reaction"], 'likes.user_id' => params["user"])
			.with_everything(Current.user, params)
	end

	private
	def like_params
		params.require(:like).permit(:post_id, :reaction)
	end

	def find_post
		@post = Post.find(params[:post_id])
	end
end
