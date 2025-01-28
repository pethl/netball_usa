class AddDiscountCodeToIndividualMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :individual_members, :discount_code, :string
    add_column :individual_members, :country, :string
  end
end
