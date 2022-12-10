module Pub
	module ActivityPubHelper
		def full_url
			"http#{Rails.env == "production" ? 's' : ''}://#{ENV['URL']}"
		end

		def http_signature(host)
			date = Time.now.utc.httpdate
			keypair = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'])
			
			signed_string = "(request-target): post /inbox\nhost: #{host}\ndate: #{date}"
			signature = Base64.strict_encode64(
				keypair.sign(OpenSSL::Digest::SHA256.new, signed_string)
			)

			keyId = "keyId=\"#{full_url}/pub/actor/lazar\""
			headers = "headers=\"(request-target) host date\""
			sig = "signature=\"#{signature}\""

			sig_header = "#{keyId},#{headers},#{sig}"
			{ Host: host, Date: date, Signature: sig_header }
		end

		def sig_check(req_headers)
			return false unless req_headers['Signature']

			sig_header = req_headers['Signature'].split(',').map do |pair|
				parts = pair.match(/(.*)=\"(.*)\"/)
				[parts[1], parts[2]]
			end.to_h
			p "sig_header: #{sig_header}"

			key_id = sig_header['keyId']
			headers = sig_header['headers']
			signature = Base64.decode64(sig_header['signature'])
			p "Signature: #{signature}"

			actor_response = HTTP.headers(
				'Content-Type' => 'application/json',
				'Accept': 'application/json'
			).get(key_id)
			return false unless actor_response.code == 200

			actor = JSON.parse(actor_response.to_s)
			key = OpenSSL::PKey::RSA.new(actor['publicKey']['publicKeyPem'])

			comparison_string = headers.split(' ').map do |header_name|
				if header_name == '(request-target)'
					'(request-target): post /inbox'
				else
					"#{header_name}: #{req_headers[header_name.capitalize]}"
				end
			end.join("\n")
			p comparison_string

			date = DateTime.parse(req_headers['Date'])
			# Check the digest
			# Check that the actor and who's following match
			key.verify(OpenSSL::Digest::SHA256.new, signature, comparison_string) &&
				date > 1.minute.ago
		end
	end
end
