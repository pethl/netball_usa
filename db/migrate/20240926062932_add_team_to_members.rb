class AddTeamToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :team_id, :integer
    add_foreign_key :members, :teams, column: :team_id
  end
end
