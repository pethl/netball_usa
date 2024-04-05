class AddFieldsToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :hotel_name, :string
    add_column :transfers, :pick_up_grouping, :integer
    add_column :transfers, :pickup_type, :string
    add_column :transfers, :pickup_note, :string
    add_column :transfers, :departure_grouping, :integer
    add_column :transfers, :departure_type, :string
    add_column :transfers, :departure_note, :string
  end
end
