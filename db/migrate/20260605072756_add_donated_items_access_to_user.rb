class AddDonatedItemsAccessToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :donated_items_access, :boolean, default: false, null: false
  end
end
