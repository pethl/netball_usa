class Add2FieldToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :arrival_terminal, :string
    add_column :transfers, :departure_terminal, :string
    add_column :transfers, :pickup_location, :string
  end
end
