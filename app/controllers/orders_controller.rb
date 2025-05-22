class OrdersController < ApplicationController
  before_action :authenticate_user!,      only: [:index, :create]
  before_action :authenticate_non_admin!, only: [:index]
  before_action :redirect_if_sold_out,    only: [:index, :create]

  def index
    @item = Item.find_by(id: params[:item_id])
    if @item.present?
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      gon.user_point = current_user.point
      gon.item_price = @item.price
      gon.user_coupons = current_user.coupon_assignments.includes(:coupon).each_with_object({}) do |assignment, hash|
        hash[assignment.id] = assignment.coupon.discount_rate
      end

      @order = Order.new(user: current_user, item: @item)
      @order.build_delivery_address
      @coupon_options = current_user.coupon_assignments.includes(:coupon).map do |assignment|
        coupon = assignment.coupon
        label = []
        label << coupon.name.presence
        label << "#{coupon.discount_rate}%"
        label << "#{coupon.expires_at.to_date}"
        [label.compact.join(' / '), assignment.id] # ← valueはassignment.id
      end

    else
      flash.now[:alert] = '商品が見つかりません。'
      redirect_to root_path
    end
  end

  def create
    @order = Order.new(order_params)
    return render_index_with_item(alert: '入力内容に誤りがあります。') unless @order.valid?

    return render_index_with_item(alert: '不正なクーポンが選択されています') unless valid_coupon_assignment?(@order)

    validate_used_point!(@order)

    charge_amount = @order.charge_amount
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    begin
      charge = Payjp::Charge.create(amount: charge_amount, card: order_params[:token], currency: 'jpy')
    rescue Payjp::CardError => e
      @order.errors.add(:base, "カードエラー: #{e.message}")
      return render_index_with_item(alert: "カードエラー: #{e.message}")
    rescue StandardError => e
      @order.errors.add(:base, "予期せぬエラー: #{e.message}")
      return render_index_with_item(alert: "予期せぬエラーが発生しました: #{e.message}")
    end
    if charge&.paid
      update_user_point_balance(@order, charge_amount)
      delete_used_coupon_assignment(@order)
      @order.save!
      return redirect_to root_path, notice: '注文が完了しました。'
    end
    render_index_with_item(alert: '支払いに失敗しました。もう一度お試しください。')
  end

  private

  def render_index_with_item(status: :unprocessable_entity, alert: nil)
    @item = Item.find(params[:item_id])
    flash.now[:alert] = alert if alert.present?
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
    gon.user_point = current_user.point
    gon.item_price = @item.price
    gon.user_coupons = current_user.coupon_assignments.includes(:coupon).index_with do |assignment|
      assignment.coupon.discount_rate
    end


    @order ||= Order.new(user: current_user, item: @item)
    @order.build_delivery_address unless @order.delivery_address

    @coupon_options = current_user.coupon_assignments.includes(:coupon).map do |assignment|
      coupon = assignment.coupon
      label = []
      label << coupon.name.presence
      label << "#{coupon.discount_rate}%"
      label << "#{coupon.expires_at.to_date}"
      [label.compact.join(' / '), assignment.id] # ← valueはassignment.id
    end

    render :index, status: status
  end

  def order_params
    params.require(:order).permit(
      :user_id, :used_point, :coupon_assignment_id,
      delivery_address_attributes: [
        :postal_code, :prefecture_id, :city, :address1, :building, :phone_number
      ]
    ).merge(token: params[:token], item_id: params[:item_id])
  end

  def authenticate_non_admin!
    # current_userがnilの場合はerrorが起きてしまうが、先にauthenticate_user!でnilかどうかを確認するようにする
    return unless current_user.admin?

    # TODO: flashを表示する設定はしていない
    flash[:alert] = '一般ユーザーしか購入できません'
    redirect_to root_path
  end

  # 以下はcreateで使用するメソッドである

  def redirect_if_sold_out
    item = Item.find(params[:item_id])
    return unless item.sold_out?

    flash[:alert] = 'この商品はすでに購入されています。'
    redirect_to root_path
  end

  def update_user_point_balance(order, charge_amount)
    reward_point = charge_amount / 200
    user = order.user
    user.update_column(:point, user.point - order.used_point + reward_point)
  end

  def delete_used_coupon_assignment(order)
    return if order.coupon_assignment.blank?

    order.coupon_assignment.destroy
  end

  def validate_used_point!(order)
    if order.used_point.negative? || current_user.point < order.used_point
      raise '使用ポイントが不正です（0以上で、所持ポイント以下にしてください）'
    elsif order.used_point > order.item.price
      raise '使用ポイントが商品価格を超えています。'
    end
  end

  def valid_coupon_assignment?(order)
    return true if order.coupon_assignment_id.blank?

    current_user.coupon_assignments.exists?(id: order.coupon_assignment_id)
  end
end
