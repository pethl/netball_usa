class CorrectAmountSpelling < ActiveRecord::Migration[7.0]
  def change
    remove_column :equipment, :purchase_ammount, :decimal
    add_column :equipment, :purchase_amount, :decimal
  end
end
