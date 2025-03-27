class AddEditsToTransfers < ActiveRecord::Migration[7.2]
  def change
    add_column :transfers, :obtain_headshot, :boolean
    add_column :transfers, :airport_transport_request, :string
    add_column :transfers, :grouping_pickup_time, :datetime
    add_column :transfers, :grouping_departure_time, :datetime
    add_column :transfers, :departure_meetup_location, :string
    add_column :transfers, :hotel_confirmation_personal, :string
    add_column :transfers, :dietary_requirements_allergies, :string
  end
end
