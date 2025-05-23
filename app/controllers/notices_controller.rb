class NoticesController < ApplicationController
  def index
    @notices = Notice.all.order(created_at: :desc)
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)

    if @notice.save
      redirect_to notices_path, notice: 'プロモーションが作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    notice = Notice.find_by(id: params[:id])
    if notice
      notice.destroy
      redirect_to notices_path, notice: "#{notice.title} を削除しました。"
    else
      redirect_to notices_path, alert: '指定されたユーザーは存在しません。'
    end
  end

  private

  def notice_params
    params.require(:notice).permit(:title, :content)
  end
end
