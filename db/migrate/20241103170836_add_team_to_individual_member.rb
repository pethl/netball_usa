class AddTeamToIndividualMember < ActiveRecord::Migration[7.0]
  def change
    add_column :individual_members, :team_id, :integer
    add_foreign_key :individual_members, :teams, column: :team_id
  end
end
