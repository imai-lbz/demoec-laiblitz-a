class CreateDeliveryAdresses < ActiveRecord::Migration[7.1]
  def change
    create_table :delivery_adresses do |t|
      t.references :order, null: false, foreign_key: true
      t.string :postal_code, null: false
      t.integer :prefecture_id, null: false
      t.string :city, null: false
      t.string :address1, null: false
      t.string :building
      t.string :phone_number, null: false

      t.timestamps
    end
  end
end
