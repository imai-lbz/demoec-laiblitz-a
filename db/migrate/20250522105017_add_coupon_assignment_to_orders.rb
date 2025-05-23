# class AddCouponAssignmentToOrders < ActiveRecord::Migration[7.1]
#   def change
#     add_reference :orders, :coupon_assignment, null: false, foreign_key: true
#   end
# end

class AddCouponAssignmentToOrders < ActiveRecord::Migration[6.1]
  def change
    unless column_exists?(:orders, :coupon_assignment_id)
      add_reference :orders, :coupon_assignment, null: false, foreign_key: true
    end
  end
end

