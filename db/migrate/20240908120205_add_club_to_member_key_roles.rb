class AddClubToMemberKeyRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :member_key_roles, :club_id, :integer
    add_foreign_key :member_key_roles, :clubs, column: :club_id
  end
end
