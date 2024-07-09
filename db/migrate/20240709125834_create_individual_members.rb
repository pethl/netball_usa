class CreateIndividualMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :individual_members do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :city
      t.string :state
      t.string :gender
      t.boolean :interested_in_coaching
      t.boolean :interested_in_umpiring
      t.boolean :interested_in_usa_team
      t.string :place_of_birth
      t.string :age_status
      t.string :engagement_status
      t.string :membership_type
      t.text :notes

      t.timestamps
    end
  end
end
