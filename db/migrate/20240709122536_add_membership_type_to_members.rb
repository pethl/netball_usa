class AddMembershipTypeToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :membership_type, :string
  end
end
