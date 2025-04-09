class AddRenewalToIndividualMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :individual_members, :renewal_years, :text
    add_column :individual_members, :renewal_response, :string
  end
end
