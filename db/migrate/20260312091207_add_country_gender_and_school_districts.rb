class AddCountryGenderAndSchoolDistricts < ActiveRecord::Migration[7.1]
  def change
    add_column :netball_educators, :gender, :string
    add_column :netball_educators, :country, :string
    add_column :netball_educators, :school_district, :string
  end
end
