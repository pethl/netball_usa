class CreateClubs < ActiveRecord::Migration[7.0]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :city
      t.string :us_state
      t.string :membership_category
      t.string :website
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.text :other_sm
      t.integer :estimate_total_number_of_club_members
      t.integer :estimate_total_active_members
      t.integer :estimate_total_part_time_members

      t.timestamps
    end
  end
end
