class CouponsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin_user!
  def index
    # binding.pry
    @coupons = Coupon.all
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(coupon_params)
    if @coupon.save
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
