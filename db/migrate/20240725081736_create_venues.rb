class CreateVenues < ActiveRecord::Migration[7.0]
  def change
    create_table :venues do |t|
      t.string :facility_type
      t.string :venue_name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :website
      t.string :contact_name
      t.string :phone
      t.string :email
      t.string :permit_application_link
      t.string :grant_information_link
      t.string :number_of_courts
      t.string :size_of_courts
      t.string :retractable_basketball_hoops
      t.string :space_from_courts_to_wall
      t.string :seating_available
      t.text :restaurant_onsite
      t.text :facilities_close_by
      t.string :locker_rooms_onsite
      t.string :pool
      t.string :hot_tub
      t.string :bed_types
      t.decimal :cost_per_hour
      t.decimal :cost_per_day
      t.decimal :cost_per_night
      t.text :notes

      t.timestamps
    end
  end
end
