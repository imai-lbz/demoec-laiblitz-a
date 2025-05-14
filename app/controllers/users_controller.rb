class UsersController < ApplicationController
  def index
    # @users = User.all
  end

  # 管理者を表すadmin_flagカラムはここで設定するべきではない
  # 悪意を持ったユーザーがadmin_flagをフロントで操作する可能性が生まれるからである
  def admin_new
    @user = User.new
    render 'admin_users/new' # views/users/にないため指定する必要がある
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to items_path
    else
      render :new
    end
  end

  def destroy
  end
end
