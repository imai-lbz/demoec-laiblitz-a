class CouponsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin_user!
  def index
    @coupons = Coupon.all.order(created_at: :desc)
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
      @coupon.assign_to_all_users
      redirect_to coupons_path, notice: 'クーポンが登録されました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :discount_rate, :expires_at)
  end
end
