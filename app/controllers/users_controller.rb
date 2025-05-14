class UsersController < ApplicationController
  before_action :authenticate_user!,       only: [:index]
  before_action :authenticate_admin_user!, only: [:index]
  def index
    @users = User.all
    render 'admin_users/index'
  end

  def new
    @user = User.new
  end
end
