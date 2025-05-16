class Order < ApplicationRecord
  attr_accessor :token

  belongs_to :user
  belongs_to :item

  # orderを削除するとその子要素であるdelivery_addressが自動的に削除されるための設定である
  has_one :delivery_address, dependent: :destroy
  # 子要素であるdelivery_addressも同時に保存できるようにするため
  accepts_nested_attributes_for :delivery_address
end
