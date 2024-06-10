require 'rails_helper'

RSpec.describe Pub::ActivityPubHelper do
	it 'full url' do
		expect(helper.full_url).to eq("http://localhost:3000")
	end

	describe 'http signature' do
		let(:body) do
			{
				'@context': [
					'https://www.w3.org/ns/activitystreams',
					'https://w3id.org/security/v1'
				],
			    id: "http://lazar.social/pub/actor/lazar#accepts/follows/111",
			    type: 'Accept',
			    actor: "http://lazar.social/pub/actor/lazar",
			    object: {},
			}
		end

		let(:uri) { URI.parse("https://example.com")}

		it("generates headers") do
			headers = helper.http_signature_headers(uri, JSON.generate(body))
			expect(headers[:Host]).to eq("example.com")
			# Check the date
			# Check the digest
			# Check the signature
		end
	end
end