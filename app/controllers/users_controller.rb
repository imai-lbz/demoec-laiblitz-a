class UsersController < ApplicationController
  before_action :authenticate_user!,       only: [:index, :destroy, :show]
  before_action :authenticate_admin_user!, only: [:index, :destroy]
  before_action :basic_auth, only: [:admin_new]

  def index
    @users = User.order(created_at: :desc)
    render 'admin_users/index'
  end

  def show
    @user = current_user
    # ユーザーがお気に入り登録した商品一覧を取得
    favorite_item_ids = @user.favorites.pluck(:item_id)
    @items = Item.where(id: favorite_item_ids)
    @orders = Order.order(created_at: :desc)
    # ユーザーが使用したクーポン以外を取得する
    used_coupon_ids = current_user.orders.pluck(:coupon_id)
    @coupons = Coupon.where.not(id: used_coupon_ids)
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
