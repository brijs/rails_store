class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :show]
	before_filter :correct_user,   only: [:edit, :update, :show]

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to Brij's online store"
			redirect_to @user
		else
			render :new
		end
	end

	private

	def signed_in_user
		redirect_to signin_path, notice: "Please sign in." unless signed_in?
	end

	def correct_user
		@user = User.find(params[:id])
		redirect_to current_user,  alert: "User profile is not accessible" unless current_user?(@user)
	end

end
