class AddUrlToPromotions < ActiveRecord::Migration[7.1]
  def change
    add_column :promotions, :url, :string, null: false, default: "#"
  end
end
