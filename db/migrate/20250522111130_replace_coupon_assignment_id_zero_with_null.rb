class ReplaceCouponAssignmentIdZeroWithNull < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL.squish
      UPDATE orders
      SET coupon_assignment_id = NULL
      WHERE coupon_assignment_id = 0
    SQL
  end

  def down
    # リバース操作が難しいため空のままか、0に戻す処理を明示
    execute <<-SQL.squish
      UPDATE orders
      SET coupon_assignment_id = 0
      WHERE coupon_assignment_id IS NULL
    SQL
  end
end
