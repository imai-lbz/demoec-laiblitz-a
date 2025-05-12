class ItemsController < ApplicationController
  # トップページ
  def index
  end

  # 商品管理・一覧ページ
  def dashboard
  end

  def show
  end

  def edit
  end

  def new
    @item = Item.new
  end

  def create
  end
end
