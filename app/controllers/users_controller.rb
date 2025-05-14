class UsersController < ApplicationController
  before_action :basic_auth, only: [:admin_new]

  def index
    # @users = User.all
  end

  # 管理者を表すadmin_flagカラムはここで設定するべきではない
  # 悪意を持ったユーザーがadmin_flagをフロントで操作する可能性が生まれるからである
  def admin_new
    @admin_user = User.new
    render 'admin_users/new' # views/users/にないため指定する必要がある
  end

  def new
    @user = User.new
  end

  def admin_create
    @admin_user = User.new(user_params)
    @admin_user.admin_flag = true
    if @admin_user.save
      redirect_to items_path
    else
      render :new
    end
  end

  def create
    @user = User.new(user_params)
    binding.pry

    @user.admin_flag = false
    if @user.save
      redirect_to items_path
    else
      render :new
    end
  end

  def destroy
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD'] # 環境変数を読み込む記述に変更
    end
  end
end
