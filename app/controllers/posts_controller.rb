class PostsController < ApplicationController
	def index
		@posts = Post.limit(30).offset((params[:page].to_i || 0) * 30).order(created_at: :desc)
		@params = params
		@new_post = Post.new
	end

	def show
		@post = Post.with_everything(Current.user, params).find(params[:id])
		@plies = @post.plies.with_everything(Current.user, params)
		@replies = @post.replies.with_everything(Current.user, params)
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
					@post.plies << Post.find(id)
				end
			end

			post_params[:replies].split(' ').each do |id|
				if id.present?
					# p "reply------#{id}"
					@post.replies << Post.find(id)
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
			posts: post.plies.with_everything(Current.user, params),
			up: true
		}
	end

	def replies
		post = Post.find(params[:id])
		render partial: 'carousel', locals: {
			post_id: post.id,
			posts: post.replies.with_everything(Current.user, params),
			up: false
		}
	end

	private
	def post_params
		params.require(:post).permit(:words, :replies, :plies)
	end
end
