class CreateEventTransports < ActiveRecord::Migration[7.1]
  def change
    create_table :event_transports do |t|
      t.references :transfer_event, null: false, foreign_key: { to_table: :events }
      t.datetime :departure_at, null: false
      t.datetime :arrival_at
      t.string :pickup_location, null: false
      t.string :destination, null: false
      t.string :driver_name
      t.text :notes

      t.timestamps
    end

    create_table :event_transport_passengers do |t|
      t.references :event_transport, null: false, foreign_key: true
      t.references :person, foreign_key: true
      t.string :write_in_name
      t.string :phone

      t.timestamps
    end

    add_index :event_transport_passengers,
              [:event_transport_id, :person_id],
              unique: true,
              where: "person_id IS NOT NULL",
              name: "index_event_transport_passengers_on_transport_and_person"
  end
end
