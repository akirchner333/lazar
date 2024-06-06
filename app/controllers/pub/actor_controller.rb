module Pub
	class ActorController < ApplicationController
		include ActivityPubHelper

		skip_before_action :verify_authenticity_token

		def actor
			if params[:id] == "lazar"
				render :json => Pub::Organization.new.to_h
			else
				render :json => {
					error: "not found"
				}
			end
		end

		def featured
			collection = Pub::OrderedCollection.new(
				"actor/#{params[:id]}/collections/featured",
				Post.limit(5).map { |p| p.to_note.to_h }
			)
			render :json => collection.to_h
		end

		def followers
			total = PubFollower.count
			id = "actor/#{params[:id]}/collections/followers"
			if total <= 10
				collection = Pub::OrderedCollection.new(
					id,
					PubFollower.pluck(:actor_url)
				)

				render :json => collection.to_h
			else
				if(params[:page].nil?)
					collection = Pub::OrderedCollectionRoot.new(total, id)
					render :json => collection.to_h
				else
					collection = Pub::OrderedCollectionPage.ends_with(
						total,
						id,
						params[:page],
						PubFollower.limit(10).offset(10 * params[:page]).pluck(:actor_url)
					)
					render :json => collection.to_h
				end
			end
		end
	end
end