class OrdersController < ApplicationController
  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @item = Item.find_by(params[:item_id])
    if @item.present?
      @order = Order.new(user: current_user, item: @item)
      @order.build_delivery_address(
        postal_code: '123-4567',
        prefecture_id: 1,
        city: '沖縄',
        address1: '浦添',
        phone_number: '08011112222'
      )
    else
      flash.now[:alert] = '商品が見つかりません。'
      redirect_to root_path
    end
  end

  def create
    @order = Order.new(order_params)
    return unless @order.valid?

    Payjp.api_key = ENV['PAYJP_SECRET_KEY'] # 自身のPAY.JPテスト秘密鍵を記述しましょう
    test_charge = Payjp::Charge.create(
      amount: @order.item.price, # 商品の値段
      card: order_params[:token], # カードトークン
      currency: 'jpy' # 通貨の種類（日本円）
    )

    # binding.pry

    # if @order.save
    #   redirect_to root_path, notice: '注文が完了しました。'
    # else
    #   flash.now[:alert] = '注文に失敗しました。入力内容をご確認ください。'
    #   @item = Item.find_by(params[:item_id])
    #   render :index, status: :unprocessable_entity # index ビューを再表示
    # end
  end

  private

  def order_params
    params.require(:order).permit(
      :user_id, :item_id,
      delivery_address_attributes: [
        :postal_code, :prefecture_id, :city, :address1, :building, :phone_number
      ]
    ).merge(token: params[:token])
  end
end
