class AddAddressToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :address, :string
    add_column :members, :zip, :string
  end
end
