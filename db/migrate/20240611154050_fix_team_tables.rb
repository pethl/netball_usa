class FixTeamTables < ActiveRecord::Migration[7.0]
  def change
    remove_column :members, :team_id
    rename_column :member_key_roles, :team_id, :na_team_id
  end
end
