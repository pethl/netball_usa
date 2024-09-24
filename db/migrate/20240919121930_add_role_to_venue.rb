class AddRoleToVenue < ActiveRecord::Migration[7.0]
  def change
    add_column :venues, :role, :string
  end
end
