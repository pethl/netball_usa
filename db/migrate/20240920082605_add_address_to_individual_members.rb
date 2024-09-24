class AddAddressToIndividualMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :individual_members, :address, :string
    add_column :individual_members, :zip, :string
  end
end
