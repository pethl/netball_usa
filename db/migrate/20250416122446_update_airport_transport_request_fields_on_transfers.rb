class UpdateAirportTransportRequestFieldsOnTransfers < ActiveRecord::Migration[7.1]
  def change
    rename_column :transfers, :airport_transport_request, :arrival_airport_transport_request
	  rename_column :transfers, :phone, :arrival_phone
	
    add_column :transfers, :departure_airport_transport_request, :string
	  add_column :transfers, :departure_phone, :string
  end
end
