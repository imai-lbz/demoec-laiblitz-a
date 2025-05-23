class Order < ApplicationRecord
  # 親要素を削除するために設定している
  after_destroy :destroy_item_if_unused

  attr_accessor :token

  validates :token, presence: true

  belongs_to :user
  belongs_to :item
  belongs_to :coupon, optional: true


  # orderを削除するとその子要素であるdelivery_addressが自動的に削除されるための設定である
  has_one :delivery_address, dependent: :destroy
  # 子要素であるdelivery_addressも同時に保存できるようにするため
  accepts_nested_attributes_for :delivery_address

  def discount_rate
    coupon&.discount_rate || 0
  end

  def charge_amount
    discount = item.price * discount_rate / 100
    item.price - discount - used_point.to_i
  end

  private

  def destroy_item_if_unused
    # 複数個出品（未実装）に対応するため、itemを削除する前にほかの注文で使われていないか確認している
    item.destroy if item.orders.empty?
  end
end
