class Coupon < ApplicationRecord
  validates :name, presence: true
  validates :discount_rate,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
  validates :expires_at, presence: true
end
