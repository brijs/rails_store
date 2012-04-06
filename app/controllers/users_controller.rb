class UsersController < ApplicationController
	before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :show]
	before_filter :correct_user,   only: [:edit, :update]
	before_filter :admin_user,     only: :destroy

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
		@feed_items = current_user.feed.paginate(page: params[:page])
	end

	def index
		@users = User.paginate(page: params[:page], per_page: 15)
	end	

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to Brij's online store"
			redirect_to 'static_pages#home'
		else
			render :new
		end
	end

	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User destroyed."
	    redirect_to users_path
	end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


	private

	def correct_user
		@user = User.find(params[:id])
		redirect_to current_user,  alert: "User profile is not accessible" unless current_user?(@user)
	end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end



end
