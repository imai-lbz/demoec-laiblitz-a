class AddForeignKeyToOrdersCouponAssignment < ActiveRecord::Migration[7.1]
  def change
    # カラムが存在していて、まだ外部キーが登録されていない場合だけ追加
    unless foreign_key_exists?(:orders, :coupon_assignments, column: :coupon_assignment_id)
      add_foreign_key :orders, :coupon_assignments, column: :coupon_assignment_id
    end
  end
end
