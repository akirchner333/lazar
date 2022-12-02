module Pub
	class InboxController < ApplicationController
		include ActivityPubHelper
		skip_before_action :verify_authenticity_token

		def inbox
			if helpers.sig_check(request.headers)
				render plain: 'OK', status: 200
			else
				render plain: 'Request signature could not be verified', status: 401
			end
		end

		def test
			document = JSON.generate({hello: "hello!"})

			headers = helpers.http_signature('localhost:3000')
			p headers
			response = HTTP.headers(headers)
					       .post('http://localhost:3000/pub/inbox', body: document)

			render plain: response.to_s, status: 200
		end
	end
end