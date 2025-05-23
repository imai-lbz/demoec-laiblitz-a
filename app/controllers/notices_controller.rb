class NoticesController < ApplicationController
  def index
    @notices = Notice.all.order(created_at: :desc)
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(promotion_params)

    if @notice.save
      redirect_to notices_path, notice: 'プロモーションが作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def notice_params
    params.require(:notice).permit(:title, :content)
  end
end
