class AddUsaUniversityPartnerToPartners < ActiveRecord::Migration[7.1]
  def change
    add_column :partners,
               :usa_university_partner,
               :boolean,
               null: false,
               default: false
  end
end
