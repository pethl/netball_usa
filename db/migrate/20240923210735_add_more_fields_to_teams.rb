class AddMoreFieldsToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :club_id, :integer
    remove_column :teams, :state
    remove_column :teams, :city
    remove_column :teams, :website
    remove_column :teams, :facebook
    remove_column :teams, :twitter
    remove_column :teams, :instagram
    remove_column :teams, :other_sm
    
  end
end
