class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new({**user_params, username: User.name_gen})
		if @user.save
			session[:user_id] = @user.id
			redirect_to root_path, notice: 'Account Created!'
		else
			render :new
		end
	end

	def show
		@user = User.find(params[:id])
		@posts = @user.posts.with_everything(Current.user, params)
	end

	def update
		user = User.find(params[:id])
		user.update(username: User.name_gen)
		redirect_to user
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end
end
