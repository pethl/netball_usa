class AddFkToMemberRoles < ActiveRecord::Migration[7.0]
  def change
    
    add_reference :na_teams, :member_key_role, index: true
  end
end
