class Item < ApplicationRecord
  has_one_attached :image, dependent: :purge_later

  validates :image,        presence: true
  validates :name,         presence: true
  validates :description,  presence: true
  validates :category_id,  presence: true
  validates :condition_id, presence: true
  validates :price,        presence: true, format: { with: /\A[0-9]+\z/ }, numericality: {  only_integer: true,
                                                                                            greater_than_or_equal_to: 300,
                                                                                            less_than_or_equal_to: 9_999_999 }

  has_many :orders, dependent: :destroy
  has_many :favorites, dependent: :destroy

  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :category
  belongs_to :condition

  # ユーザーがいいね済みかどうかを判定する関数
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def sold_out?
    orders.exists?
  end
end
