class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :check_current_user?, only: [:edit, :update]
	
	def show
		@user = User.find(params[:id])
		@book_new = Book.new
		@books = @user.books.all
	end

	def index
		@user = current_user
		@book_new = Book.new
		@users = User.all
	end

	def edit
		@user = User.find(params[:id])
		if current_user.id != @user.id
		   redirect_to user_path(current_user.id)
		end
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  	   flash[:notice] = "successfully"
  		redirect_to user_path(@user.id)
  	else
  		render :edit
 		end
  end

  def follows
    @user = User.find(params[:id])
    @users = @user.followed
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.follower
  end

  private

  def user_params
		params.require(:user).permit(:name, :introduction, :profile_image_id)
	end

  def check_current_user?
  	user = User.find(params[:id])
  	if current_user.id != user.id
  		redirect_to user_path(current_user.id)
  	end
  end
    	
end
