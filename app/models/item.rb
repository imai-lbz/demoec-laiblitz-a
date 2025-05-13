class Item < ApplicationRecord
  has_one_attached :image

  validates :image,        presence: true
  validates :name,         presence: true
  validates :description,  presence: true
  validates :category_id,  presence: true
  validates :condition_id, presence: true
  validates :price,        presence: true, format: { with: /\A[0-9]+\z/ }, numericality: {  only_integer: true,
                                                                                            greater_than_or_equal_to: 300,
                                                                                            less_than_or_equal_to: 9_999_999 }
end
