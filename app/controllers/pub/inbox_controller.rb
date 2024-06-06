module Pub
	class InboxController < ApplicationController
		include ActivityPubHelper
		skip_before_action :verify_authenticity_token

		def inbox
			body = JSON.parse(request.raw_post)
			if helpers.sig_check(request.headers)
				if body['type'] == "Follow" && body['object'].ends_with?('lazar')
					follower = PubFollower.create_from_activity(body)
					inbox = follower.inbox
					accept = Pub::Accept.new(follower, body)

					activity_post(inbox, accept.to_s)
				elsif body['type'] == "Undo"
					if body['object']['type'] == 'Follow'
						# Unfollow
						PubFollower.where(actor_url: body['actor']).delete_all
					end
				end

				render plain: 'OK', status: 200
			else
				render plain: 'Request signature could not be verified', status: 401
			end
		end

		def outbox
			total = Post.count
			id = "outbox"
			if total <= 10
				collection = Pub::OrderedCollection.new(
					id,
					Post.all.map { |p| p.create_object }
				)

				render :json => collection.to_h
			else
				if(params[:page].nil?)
					collection = Pub::OrderedCollectionRoot.new(total, id)
					render :json => collection.to_h
				else
					collection = Pub::OrderedCollectionPage.new(
						total,
						id,
						params[:page].to_i,
						Post.limit(10)
							.offset(10 * (params[:page].to_i - 1))
							.map { |p| p.create_object }
					)
					render :json => collection.to_h
				end
			end
		end
	end
end