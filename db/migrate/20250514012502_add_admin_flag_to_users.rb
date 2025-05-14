class AddAdminFlagToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin_flag, :boolean
    add_index  :users, :admin_flag
  end
end
