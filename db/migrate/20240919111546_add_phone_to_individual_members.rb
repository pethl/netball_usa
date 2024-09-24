class AddPhoneToIndividualMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :individual_members, :phone, :string
  end
end
