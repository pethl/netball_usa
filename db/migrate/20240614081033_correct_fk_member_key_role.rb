class CorrectFkMemberKeyRole < ActiveRecord::Migration[7.0]
  def change
    
    remove_column :member_key_roles, :na_team_id, :integer
    add_reference :member_key_roles, :na_teams
  end
end
