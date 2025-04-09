class AddRenewalYearsToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :renewal_years, :text
    add_column :clubs, :renewal_response, :string
  end
end
