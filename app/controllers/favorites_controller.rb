class FavoritesController < ApplicationController
  before_action :set_item

  def create
    current_user.favorites.create!(item: @item)

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite_item_#{@item.id}",
          partial: partial_for(request.referer),
          locals: { item: @item }
        )
      end
    end
  end

  def destroy
    current_user.favorites.find_by(item: @item)&.destroy

    respond_to do |format|
      format.html { redirect_to request.referer }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite_item_#{@item.id}",
          partial: partial_for(request.referer),
          locals: { item: @item }
        )
      end
    end
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  # リファラー（戻り元URL）に応じて部分テンプレート名を返す
  def partial_for(referer_url)
    # 詳細画面のパスが含まれていれば _btn（詳細用）を、
    # それ以外なら _btn_for_products（一覧用）を返す
    if referer_url&.include?(item_path(@item))
      'favorites/btn'
    else
      'favorites/btn_for_products'
    end
  end
end
