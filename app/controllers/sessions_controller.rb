class SessionsController < ApplicationController
	def new
		@google_client_id = Rails.configuration.x.google_auth.client_id
		@state = 'abc123'
	end

	def create
		user = User.find_by(email: params[:email])
		if user.present? && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to root_path, notice: "Logged in"
		else
			login_failure
		end
	end

	def omniauth
		@user = User.from_omniauth(auth)
		if @user.save
			session[:user_id] = @user.id
			redirect_to root_path, notice: "Logged in"
		else
			redirect_to root_path, notice: @user.errors
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path, notice: 'Logged out'
	end

	private
	def login_failure
		flash.alert = "We were unable to log you in. Please try again or make a new account."
		redirect_to sign_in_path
	end

	def auth
		request.env['omniauth.auth']
	end
end
