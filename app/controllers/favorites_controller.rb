class FavoritesController < ApplicationController
  def create
    item = Item.find(params[:item_id])
    favorite = current_user.favorites.new(item_id: item.id)
    favorite.save
    # リクエスト送信元のページ（商品詳細画面）に戻る
    redirect_to request.referer
  end

  def destroy
    item = Item.find(params[:item_id])
    favorite = current_user.favorites.find_by(item_id: item.id)
    favorite.destroy
    redirect_to request.referer
  end
end
