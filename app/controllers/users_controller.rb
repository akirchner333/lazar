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
		@posts = @user
			.posts
			.limit(30)
			.sort_method(params[:order])
			.offset((params[:page].to_i || 0) * 30)
		@new_post = Post.new
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
