module Pub
	module ActivityPubHelper
		def full_url
			"http#{Rails.env == "production" && ENV['HTTPS'] == 'true' ? 's' : ''}://#{ENV['URL']}"
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

#     let stringToSign = `(request-target): post ${inboxFragment}\n
# host: ${targetDomain}\n
# date: ${d.toUTCString()}\n
# digest: SHA-256=${digest}`;
		def sig_check(headers)
			if !headers['Signature']
				p "Signature failed due to lack of signature header"
				return false
			end

			sig_header = headers['Signature'].split(',').map do |pair|
				parts = pair.match(/(.*)=\"(.*)\"/)
				[parts[1], parts[2]]
			end.to_h

			key_id = sig_header['keyId']
			header_list = sig_header['headers']
			signature = Base64.decode64(sig_header['signature'])

			actor_response = HTTP.headers(
				'Content-Type' => 'application/activity+json',
				'Accept': 'application/activity+json'
			).get(key_id)
			if actor_response.code != 200
				p "Signature failed due to not getting the actor properly"
				return false
			end

			actor = JSON.parse(actor_response.to_s)
			key = OpenSSL::PKey::RSA.new(actor['publicKey']['publicKeyPem'])

			comparison_string = build_comp_string(header_list, headers)

			if !key.verify(OpenSSL::Digest::SHA256.new, signature, comparison_string) 
				p "Signature failed due to verify"
				p "-------------- Signature ---------------------"
				p headers['Signature']
				p "------------- header signature ---------------"
				p sig_header['signature']
				p "------------- signature ----------------------"
				p signature
				p "------------ comparison string ---------------"
				p comparison_string
				p "-----------------------------------------------"
				return false;
			end

			date = DateTime.parse(headers['Date'])
			if date < 12.hours.ago
				p "Signature failed due to the date"
				return false
			end

			p "Signature passed!"
			return true
		end

		private

		def build_comp_string(header_list, headers)
			header_list.split(' ').map do |header_name|
				if header_name == '(request-target)'
					'(request-target): post /pub/inbox'
				else
					"#{header_name}: #{headers[header_name.capitalize]}"
				end
			end.join("\n")
		end
	end
end
