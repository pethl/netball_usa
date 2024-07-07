class AddSocialsToNaTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :na_teams, :website, :string
    add_column :na_teams, :facebook, :string
    add_column :na_teams, :twitter, :string
    add_column :na_teams, :instagram, :string
    add_column :na_teams, :other_sm, :text
  end
end
