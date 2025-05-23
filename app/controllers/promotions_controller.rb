class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all.order(created_at: :desc)
  end

  def new
    @promotion = Promotion.new
  end
end
