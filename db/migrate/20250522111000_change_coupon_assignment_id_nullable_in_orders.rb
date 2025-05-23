class ChangeCouponAssignmentIdNullableInOrders < ActiveRecord::Migration[7.1]
  def change
    change_column_null :orders, :coupon_assignment_id, true
  end
end
