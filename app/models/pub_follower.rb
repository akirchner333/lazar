class PubFollower < ApplicationRecord
	# def self.create_from_params(params)
	# 	# Sometimes it'll be a url and sometimes it'll be a hash? Am I remembering that correctly?
	# 	# And then we gotta 
	# 	create(actor: params[:actor])
	# end

	def full_actor
		JSON.parse(HTTP.get(actor_url))
	end
end
