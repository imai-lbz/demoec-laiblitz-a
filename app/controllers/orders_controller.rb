class OrdersController < ApplicationController
  def index
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    @item = Item.find(params[:item_id])
    # binding.pry
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
    # TODO: chargeのエラーを@orderに追加して返すことでフロントでエラーを表示する
    binding.pry

    @order = Order.new(order_params)

    return render_index_with_item(alert: '入力内容に誤りがあります。') unless @order.valid?

    Payjp.api_key = ENV['PAYJP_SECRET_KEY'] # 自身のPAY.JPテスト秘密鍵を記述しましょう

    begin
      charge = Payjp::Charge.create(
        amount: @order.item.price, # 商品の値段
        card: order_params[:token], # カードトークン
        currency: 'jpy' # 通貨の種類（日本円）
      )
    rescue Payjp::CardError => e
      return render_index_with_item(alert: "カードエラー: #{e.message}")
    rescue StandardError => e
      return render_index_with_item(alert: "予期せぬエラーが発生しました: #{e.message}")
    end

    # binding.pry

    if charge&.paid
      @order.save!
      return redirect_to root_path, notice: '注文が完了しました。'
    end

    render_index_with_item(alert: '支払いに失敗しました。もう一度お試しください。')
  end

  private

  def render_index_with_item(status: :unprocessable_entity, alert: nil)
    @item = Item.find(params[:item_id])
    flash.now[:alert] = alert if alert.present?
    render :index, status: status
  end

  def order_params
    params.require(:order).permit(
      :user_id,
      delivery_address_attributes: [
        :postal_code, :prefecture_id, :city, :address1, :building, :phone_number
      ]
    ).merge(token: params[:token], item_id: params[:item_id])
  end
end
