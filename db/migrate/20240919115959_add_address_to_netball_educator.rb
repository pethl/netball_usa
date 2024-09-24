class AddAddressToNetballEducator < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :address, :string
  end
end
