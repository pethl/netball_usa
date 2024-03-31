class CreateEquipment < ActiveRecord::Migration[7.0]
  def change
    create_table :equipment do |t|
      t.text :items_purchased
      t.decimal :purchase_ammount

      t.timestamps
    end
  end
end
