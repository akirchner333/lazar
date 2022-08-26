class PostsController < ApplicationController
	def index
		if ENV['SITE_LIVE'] == 'true'
			@posts = Post.all
				.with_likes(Current.user.id)
				.where(generation: 6)
				.order(created_at: :asc)
				.limit(500)
			@params = params
			@new_post = Post.new
		else
			render 'static/not_live'
		end
	end

	def show
		@post = Post.with_likes(Current.user.id).find(params[:id])
		@new_post = Post.new
	end

	def create
		@post = Post.new(
			words: post_params[:words], 
			user: Current.user,
			generation: 6
		)

		if @post.save
			post_params[:plies].split(' ').each do |id|
				if id.present?
					p "ply------#{id}"
					@post.replies << Post.find(id)
				end
			end

			post_params[:replies].split(' ').each do |id|
				if id.present?
					p "reply------#{id}"
					@post.plies << Post.find(id)
				end
			end

			redirect_to @post
		else
			p @post.errors
		end
	end

	private
	def post_params
		params.require(:post).permit(:words, :replies, :plies)
	end
end
