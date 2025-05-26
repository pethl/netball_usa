class AddCountryToTours < ActiveRecord::Migration[7.1]
  def change
    add_column :tours, :country, :string
  end
end
