class CouponAssignment < ApplicationRecord
  belongs_to :user
  belongs_to :coupon
end
