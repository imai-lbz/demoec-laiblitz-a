# class FavoritesController < ApplicationController
#   def create
#     item = Item.find(params[:item_id])
#     favorite = current_user.favorites.new(item_id: item.id)
#     favorite.save
#     # リクエスト送信元のページ（商品詳細画面）に戻る
#     redirect_to request.referer
#   end

#   def destroy
#     item = Item.find(params[:item_id])
#     favorite = current_user.favorites.find_by(item_id: item.id)
#     favorite.destroy
#     redirect_to request.referer
#   end
# end

class FavoritesController < ApplicationController
  before_action :set_item

  def create
    current_user.favorites.create!(item: @item)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream
    end
  end

  def destroy
    current_user.favorites.find_by(item: @item)&.destroy
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
