class AddUsedPointToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :used_point, :integer, null: false, default: 0
  end
end
