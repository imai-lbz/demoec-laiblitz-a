class CouponsController < ApplicationController
  def index
    # binding.pry
  end

  def new
    @coupon = Coupon.new
  end

  def create
  end
end
