module Pub
	class FingerController < ApplicationController
		def webfinger
			account = params[:resource].match(/acct:(.*)@lazar.social/)
			if account && account[1] && account[1].downcase == 'lazar'
				render :json => {
					subject: "acct:lazar@#{ENV['URL']}",
					links: [
						{
							rel: "self",
							type: "application/activity+json",
							href: "https://#{ENV['URL']}/pub/actor/lazar"
						},{
							rel: "http://webfinger.net/rel/profile-page",
							type: "text/html",
							href: "https://#{ENV['URL']}"
						}
					]
				}
			else
				render plain: '', status: 404
			end
		end
	end
end

# the webfinger spec https://tools.ietf.org/html/rfc7033
# mastodon spec https://docs.joinmastodon.org/spec/webfinger

# Eventually I may add a second lazar account, one for the feed and one for announcements
# Or even let everybody federate their accounts
# But this is sufficient for now