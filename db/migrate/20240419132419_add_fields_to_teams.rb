class AddFieldsToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :city, :string
    add_column :teams, :website, :string
    add_column :teams, :facebook, :string
    add_column :teams, :twitter, :string
    add_column :teams, :instagram, :string
    add_column :teams, :other_sm, :string
  end
end
