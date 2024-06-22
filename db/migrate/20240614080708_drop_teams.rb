class DropTeams < ActiveRecord::Migration[7.0]
  def change
    drop_table :taems
    drop_table :educators
  end
end
