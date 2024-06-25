class StaticController < ApplicationController
	def help
	end

	def landing
		@posts = Post.limit(5).order(created_at: :desc)
		if ENV['SITE_LIVE'] != 'true'
			render 'not_live'
		elsif Current.user
			redirect_to "/posts"
		end
	end

	def museum
	end

	def rotate
		render layout: false
	end
end
