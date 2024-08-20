class CreatePartners < ActiveRecord::Migration[7.0]
  def change
    create_table :partners do |t|
      t.string :company
      t.text :description
      t.string :location
      t.string :city
      t.string :state
      t.string :website
      t.datetime :date_initially_connected
      t.datetime :date_pitch_to_na
      t.datetime :date_pitch_by_na
      t.text :pitch_to_na
      t.text :pitch_by_na
      t.text :follow_up_action
      t.text :partnership_agreement
      t.string :accept_partnership
      t.datetime :date_of_decision

      t.timestamps
    end
  end
end
