class PostsController < ApplicationController
	def index
		if ENV['SITE_LIVE'] == 'true'
			@posts = Post.all
				.with_likes(Current.user.id)
				.sort_method(params[:order])
				.offset((params[:page].to_i || 0) * 30)
				.limit(30)
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
					# p "ply------#{id}"
					@post.replies << Post.find(id)
				end
			end

			post_params[:replies].split(' ').each do |id|
				if id.present?
					# p "reply------#{id}"
					@post.plies << Post.find(id)
				end
			end

			redirect_to @post
		else
			p @post.errors
		end
	end

	def random
		id = Post.offset(rand(Post.count)).limit(1).pluck(:id)
		redirect_to "/posts/#{id[0]}"
	end

	def plies
		post = Post.find(params[:id])

		render partial: 'carousel', locals: {
			post_id: post.id,
			posts: post.plies.with_likes(Current.user.id),
			up: true
		}
	end

	def replies
		post = Post.find(params[:id])
		render partial: 'carousel', locals: {
			post_id: post.id,
			posts: post.replies.with_likes(Current.user.id),
			up: false
		}
	end

	private
	def post_params
		params.require(:post).permit(:words, :replies, :plies)
	end
end
