class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :event_type
      t.string :name
      t.datetime :date
      t.string :website
      t.text :key_contact
      t.string :city
      t.string :state
      t.string :location
      t.text :details
      t.string :booth
      t.text :cost_notes
      t.string :status
      t.string :outcome

      t.timestamps
    end
  end
end
