class ReplaceCouponAssignmentWithCouponInOrders < ActiveRecord::Migration[7.1]
  def change
    # 外部キー制約とインデックスを含めて削除
    remove_foreign_key :orders, :coupon_assignments
    remove_column :orders, :coupon_assignment_id, :bigint

    # 新しい coupon_id を追加（NULLを許容）
    add_reference :orders, :coupon, foreign_key: true, null: true
  end
end
