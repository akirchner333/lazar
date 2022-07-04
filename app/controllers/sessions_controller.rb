class SessionsController < ApplicationController
	def new; end

	def create
		user = User.find_by(email: params[:email])
		if user.present? && user.authenticate(params[:password])
			session[:user_id] = user.id
			redirect_to root_path, notice: "Logged in"
		else
			flash.now[:alert] = 'Invalid email or password'
			render :new
		end
	end

	def create_google
		if user = authenticate_with_google
			session[:user_id] = user.id
			redirect_to root_path, notice: "Logged in"
		else
			flash.now[:alert] = "Problem logging in"
			render :new
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path, notice: 'Logged out'
	end

	private
	# I don't know what any of this stuff means!
	def authenticate_with_google
		if id_token = flash[:google_sign_in][:id_token]
			User.find_by(google_id: GoogleSignIn::Identity.new(id_token).user_id)
		elsif error = flash[:google_sign_in]
			p "OH NO!"
			nil
		end
	end
end
