class AddRoleToNetballeducators < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :role, :string
  end
end
