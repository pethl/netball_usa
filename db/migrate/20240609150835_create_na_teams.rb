class CreateNaTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :na_teams do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
