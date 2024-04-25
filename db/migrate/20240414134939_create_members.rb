class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.references :team, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :city
      t.string :state
      t.string :gender
      t.boolean :interested_in_coaching
      t.boolean :interested_in_umpiring
      t.boolean :interested_in_usa_team
      t.datetime :dob
      t.string :place_of_birth
      t.text :notes

      t.timestamps
    end
  end
end
