class ItemsController < ApplicationController
  # ログインしていない場合はログインページに強制遷移させる。
  # TODO: 管理者ユーザーで実際に挙動を確認する必要がある
  before_action :authenticate_user!,         only: [:new, :edit, :dashboard, :destroy]
  before_action :authenticate_admin_user!,   only: [:new, :edit, :dashboard, :destroy]
  before_action :set_promotions_and_notices, only: [:index, :search]
  # before_action :apply_gon_for_js,           only: [:index, :search]

  # トップページ
  def index
    @items = Item.order(created_at: :desc)
    @items = @items.where(condition_id: params[:condition_id]) if params[:condition_id].present?
    @search_keyword = ''
    apply_gon_for_js(@items)
  end

  # app/controllers/items_controller.rb
  def favorite_frame
    @item = Item.find(params[:id])
    render partial: 'favorites/btn_for_products', locals: { item: @item }
  end

  def search
    @search_keyword = "#{params[:q]}"
    @items = Item.where('name LIKE ? OR description LIKE ?', "%#{@search_keyword}%",
                        "%#{@search_keyword}%").order(created_at: :desc)
    apply_gon_for_js(@items)
    render :index
  end

  # 商品管理・一覧ページ
  def dashboard
    @items = Item.order(created_at: :desc)
    render 'items/dashboard'
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    uploaded_file = params[:item][:image]

    if uploaded_file.present? && !valid_image?(uploaded_file)
      @item.errors.add(:image, 'が正しいファイルではありません')
      return render :new, status: :unprocessable_entity
    end
    if @item.update(item_params)
      redirect_to dashboard_items_path, notice:
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to dashboard_items_path
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    uploaded_file = params[:item][:image]

    if uploaded_file.present? && !valid_image?(uploaded_file)
      @item.errors.add(:image, 'が正しいファイルではありません')
      return render :new, status: :unprocessable_entity
    end
    if @item.save
      redirect_to dashboard_items_path
    else
      render :new, status: :unprocessable_entity # HTTPステータスコード422を返す。バリデーションエラーを示す。
    end
  end

  private

  def valid_image?(uploaded_file)
    return false unless uploaded_file.respond_to?(:tempfile)

    type = FastImage.type(uploaded_file.tempfile)
    %i[jpeg png gif webp bmp tiff].include?(type)
  end

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :condition_id, :price, :image)
  end

  def set_promotions_and_notices
    @promotions = Promotion.order(updated_at: :desc)
    @notices = Notice.order(created_at: :desc)
  end

  def apply_gon_for_js(items)
    gon.items = items.map do |item|
      {
        id: item.id,
        name: item.name,
        price: item.price,
        condition_id: item.condition_id,
        condition_name: item.condition&.name,
        category_id: item.category_id,
        category_name: item.category&.name,
        image_url: item.image.attached? ? url_for(item.image) : nil,
        is_sold_out: item.sold_out?
      }
    end
    gon.categories = Category.all.map { |c| { id: c.id, name: c.name } }
    gon.current_user = current_user
  end
end
