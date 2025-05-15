class ItemsController < ApplicationController
  # ログインしていない場合はログインページに強制遷移させる。
  # TODO: 管理者ユーザーで実際に挙動を確認する必要がある
  before_action :authenticate_user!,       only: [:new]
  before_action :authenticate_admin_user!, only: [:new]

  # トップページ
  def index
    @items = Item.order(created_at: :desc)
  end

  # 商品管理・一覧ページ
  def dashboard
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to dashboard_items_path
    else
      render :new, status: :unprocessable_entity # HTTPステータスコード422を返す。バリデーションエラーを示す。
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :condition_id, :price, :image)
  end
end
