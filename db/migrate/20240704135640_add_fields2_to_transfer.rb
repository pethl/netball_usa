class AddFields2ToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :hotel_arrival, :string
    add_column :transfers, :hotel_departure, :string
  end
end
