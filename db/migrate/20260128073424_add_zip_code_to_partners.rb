class AddZipCodeToPartners < ActiveRecord::Migration[7.1]
  def change
    add_column :partners, :zip_code, :string
  end
end
