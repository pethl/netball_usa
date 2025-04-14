class AddStatusToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :status, :string, default: "Active", null: false
  end
end
