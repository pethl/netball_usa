class AddNaTeamtoMember < ActiveRecord::Migration[7.0]
  def change
    add_reference :members, :na_team, index: true
  end
end
