class ApplicationController < ActionController::Base
	before_action :set_current_user, :get_stats

	def get_stats
		@total = Post.sum(:distance)
		@daily = Post.where("created_at >= ?", 1.days.ago).sum(:distance)
	end

	def set_current_user
		user = User.find_by(id: session[:user_id]) if session[:user_id]
		if user && (live? || user.admin)
			Current.user = user
		end
	end

	def require_user_logged_in!
		redirect_to sign_in_path, alert: "You gotta sign in" if Current.user.nil?
	end

	def live?
		ENV['SITE_LIVE'] == 'true'
	end
end
