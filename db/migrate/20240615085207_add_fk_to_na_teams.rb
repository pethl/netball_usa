class AddFkToNaTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :member_key_roles, :na_team_id, :integer
  end
end
