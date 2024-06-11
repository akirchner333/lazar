module Pub
	class ActivitiesController < ApplicationController
		include ActivityPubHelper

		skip_before_action :verify_authenticity_token

		def show
			# The only activity I currently care about is creating a post
			# So I can just treat this as another way to get posts
			post = Post.find(params[:id])
			if !post.nil?
				render :json => post.create_object
			else
				render :json => {
					error: 'not found'
				}
			end
		end
	end
end