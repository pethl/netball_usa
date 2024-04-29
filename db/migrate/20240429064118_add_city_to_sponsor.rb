class AddCityToSponsor < ActiveRecord::Migration[7.0]
  def change
    add_column :sponsors, :city, :string
    add_column :sponsors, :state, :string
  end
end
