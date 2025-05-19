class UsersController < ApplicationController
  before_action :authenticate_user!,       only: [:index, :destroy]
  before_action :authenticate_admin_user!, only: [:index, :destroy]
  before_action :basic_auth, only: [:admin_new]

  def index
    @users = User.all
    render 'admin_users/index'
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user
      user.destroy
      redirect_to users_path, notice: "#{user.nickname} を削除しました。"
    else
      redirect_to users_path, alert: '指定されたユーザーは存在しません。'
    end
  end

  # 管理者を表すadmin_flagカラムはここで設定するべきではない
  # 悪意を持ったユーザーがadmin_flagをフロントで操作する可能性が生まれるからである
  def admin_new
    @admin_user = User.new
    render 'admin_users/new' # views/users/にないため指定する必要がある
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['BASIC_AUTH_USER'] && password == ENV['BASIC_AUTH_PASSWORD'] # 環境変数を読み込む記述に変更
    end
  end
end
