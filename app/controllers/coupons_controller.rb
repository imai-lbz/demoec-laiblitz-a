class CouponsController < ApplicationController
  def index
    # binding.pry
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
