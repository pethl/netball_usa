class AddQuoteFieldsToEquipment < ActiveRecord::Migration[7.1]
  def change
    add_column :equipment, :status, :string

    add_column :equipment, :customer_name, :string
    add_column :equipment, :customer_email, :string
    add_column :equipment, :customer_address, :text
    add_column :equipment, :items_quoted, :text
    add_column :equipment, :quote_amount, :decimal, precision: 10, scale: 2

    add_index :equipment, :status
  end
end
