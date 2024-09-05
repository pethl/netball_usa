class CreateTours < ActiveRecord::Migration[7.0]
  def change
    create_table :tours do |t|
      t.string :company
      t.text :description
      t.text :location
      t.string :city
      t.string :us_state
      t.string :website
      t.datetime :date_initially_connected
      t.datetime :date_pitch_to_na
      t.datetime :date_pitch_by_na
      t.text :pitch_to_na
      t.text :pitch_by_na
      t.text :follow_up_action
      t.text :tour_agreement
      t.string :accept_tour
      t.datetime :date_of_decision
      t.string :first_name_primary
      t.string :last_name_primary
      t.string :role_primary
      t.string :email_primary
      t.string :cell_primary
      t.string :work_phone_primary
      t.string :first_name_secondary
      t.string :last_name_secondary
      t.string :role_secondary
      t.string :email_secondary
      t.string :cell_secondary
      t.string :work_phone_secondary
      t.string :first_name_third
      t.string :last_name_third
      t.string :role_third
      t.string :email_third
      t.string :cell_third
      t.string :work_phone_third

      t.timestamps
    end
  end
end
