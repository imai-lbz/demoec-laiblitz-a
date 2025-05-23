class CouponAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :coupon
  has_one    :order
end
