class UsersController < ApplicationController
  def index
    @users = User.all
    render 'admin_users/index'
  end

  def new
    @user = User.new
  end

  # def create
  #   @user = User.new(user_params)
  #   if @user.save
  #     redirect_to items_path
  #   else
  #     render :new
  #   end
  # end

  # def destroy
  # end
end
