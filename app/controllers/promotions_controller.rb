class PromotionsController < ApplicationController
  def index
    @promotions = Promotion.all.order(created_at: :desc)
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)

    if @promotion.save
      redirect_to promotions_path, notice: 'プロモーションが作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @promotion = Promotion.includes(image_attachment: :blob).find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update(promotion_params)
      redirect_to promotions_path, notice: 'プロモーションが編集されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    promotion = Promotion.find_by(id: params[:id])
    if promotion
      promotion.destroy
      redirect_to promotions_path, notice: "#{promotion.title} を削除しました。"
    else
      redirect_to promotions_path, alert: '指定されたユーザーは存在しません。'
    end
  end

  private

  def promotion_params
    params.require(:promotion).permit(:title, :content, :image)
  end
end
