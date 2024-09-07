class AddCountryToPartner < ActiveRecord::Migration[7.0]
  def change
    add_column :partners, :country, :string

  end
end
