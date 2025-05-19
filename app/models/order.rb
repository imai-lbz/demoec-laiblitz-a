class Order < ApplicationRecord
  after_destroy :destroy_item_if_unused

  attr_accessor :token

  validates :token, presence: true

  belongs_to :user
  belongs_to :item

  # orderを削除するとその子要素であるdelivery_addressが自動的に削除されるための設定である
  has_one :delivery_address, dependent: :destroy
  # 子要素であるdelivery_addressも同時に保存できるようにするため
  accepts_nested_attributes_for :delivery_address

  private

  def destroy_item_if_unused
    # ほかの注文で使われていなければ item を削除
    item.destroy if item.orders.empty?
  end
end
