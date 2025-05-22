class CreateCouponAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_assignments do |t|
      t.references :user,   null: false, foreign_key: true
      t.references :coupon, null: false, foreign_key: true

      t.timestamps
    end

    # 同じクーポンを同じユーザーに重複して配布しないようにユニーク制約を追加
    add_index :coupon_assignments, [:user_id, :coupon_id], unique: true
  end
end
