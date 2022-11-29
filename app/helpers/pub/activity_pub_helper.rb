module Pub
	module ActivityPubHelper
		def http_signature(host)
			date = Time.now.utc.httpdate
			keypair = OpenSSL::PKey::RSA.new(ENV['PRIVATE_KEY'])
			signed_string = "(request-target): post /inbox\nhost: #{host}\ndate: #{date}"
			signature = Base64.strict_encode64(keypair.sign(OpenSSL::Digest::SHA256.new, signed_string))
			header = "keyId=\"https://#{ENV['url']}/actor\",headers=\"(request-target) host date\",signature=\"#{signature}\""
			{ 'Host': host, 'Date': date, 'Signature': header }
		end
	end
end
