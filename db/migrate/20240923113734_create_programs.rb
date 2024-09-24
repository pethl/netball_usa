class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.string :program_stage
      t.string :program_name
      t.string :na_program_contact_email
      t.string :na_program_contact_phone
      t.string :location_name
      t.string :location_contact_phone
      t.string :location_contact_email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.references :people, null: true, foreign_key: true
      t.datetime :program_event_datetime
      t.string :timezone
      t.string :funded_by
      t.text :notes

      t.timestamps
    end
  end
end
