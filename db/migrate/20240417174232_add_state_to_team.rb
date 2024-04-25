class AddStateToTeam < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :state, :string
  end
end
