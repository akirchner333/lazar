class PostsController < ApplicationController
	def index
		@posts = Post
			.limit(30)
			.offset((params[:page].to_i || 0) * 30)
			.order(created_at: :desc)
		@new_post = Post.new
	end

	def show
		@post = Post.with_everything(Current.user, params).find(params[:id])
		@new_post = Post.new
	end

	def new
		@parent = Post.find(params[:id])
		@new_post = Post.new
	end

	def create
		@new_post = Post.new(	
			words: post_params[:words], 
			user: Current.user,
			generation: 7,
			parent_id: post_params[:parent]
		)

		if @new_post.save
			redirect_to @new_post
		else
			@parent = Post.find(post_params[:parent])
			render :new, status: 422
		end
	end

	def random
		id = Post.offset(rand(Post.count)).limit(1).pluck(:id)
		redirect_to "/posts/#{id[0]}"
	end

	private
	def post_params
		params.require(:post).permit(:words, :replies, :plies, :parent)
	end
end
