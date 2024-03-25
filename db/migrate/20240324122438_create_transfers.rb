class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.datetime :check_in
      t.datetime :check_out
      t.string :room_type
      t.string :hotel_reservation
      t.string :share_volunteer
      t.string :arrival_airline
      t.string :arrival_flight
      t.datetime :arrival_time
      t.string :departure_airline
      t.string :departure_flight
      t.datetime :departure_time
      t.boolean :no_pick_up
      t.text :notes

      t.timestamps
    end
  end
end
