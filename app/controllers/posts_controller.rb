class PostsController < ApplicationController
	def index
		if ENV['SITE_LIVE'] == 'true'
			@posts = Post.all.where(generation: 6).order(created_at: :desc).limit(500)
			@post = Post.new
			@params = params
		else
			render 'static/not_live'
		end
	end

	def show
		@post = Post.find(params[:id])
	end

	def create
		@post = Post.new(
			words: post_params[:words], 
			user: Current.user
		)

		if @post.save
			@post = Post.new
			redirect_to :posts
		else
			p "No"
		end
	end

	private
	def post_params
		params.require(:post).permit(:words)
	end
end
