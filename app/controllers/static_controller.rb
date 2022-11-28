class StaticController < ApplicationController
	def help
	end

	def landing
		if ENV['SITE_LIVE'] != 'true'
			render 'not_live'
		elsif Current.user
			redirect_to "/posts"
		end
	end
end
