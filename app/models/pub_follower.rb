class PubFollower < ApplicationRecord
	# def self.create_from_params(params)
	# 	# Sometimes it'll be a url and sometimes it'll be a hash? Am I remembering that correctly?
	# 	# And then we gotta 
	# 	create(actor: params[:actor])
	# end

	# What should I do if the user gets deleted or moved?
	def full_actor
		response = HTTP.headers(
			'Content-Type' => 'application/activity+json',
			'Accept': 'application/activity+json'
		).get(key_id)
		# return false unless actor_response.code == 200

		JSON.parse(response.to_s)
	end
end
