class AddCityStateCountryToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :city, :string
    add_column :people, :state, :string
    add_column :people, :country, :string
  end
end
