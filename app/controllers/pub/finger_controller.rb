module Pub
	class FingerController < ApplicationController
		include ActivityPubHelper
		def webfinger
			account = params[:resource]&.match(/acct:(.*)@#{ENV['URL']}/)
			if account && account[1] && account[1].downcase.include?('lazar')
				render :json => {
					subject: "acct:lazar@#{ENV['URL']}",
					links: [
						{
							rel: "self",
							type: "application/activity+json",
							href: "#{full_url}/pub/actor/lazar"
						},{
							rel: "http://webfinger.net/rel/profile-page",
							type: "text/html",
							href: "#{full_url}"
						}
					]
				}
			else
				render plain: '', status: 400
			end
		end
	end
end

# the webfinger spec https://tools.ietf.org/html/rfc7033
# mastodon spec https://docs.joinmastodon.org/spec/webfinger

# Eventually I may add a second lazar account, one for the feed and one for announcements
# Or even let everybody federate their accounts
# But this is sufficient for now