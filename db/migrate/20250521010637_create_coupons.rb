class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string   :name         , null: false
      t.integer  :discount_rate, null: false
      t.datetime :expires_at   , null: false

      t.timestamps
    end
  end
end
