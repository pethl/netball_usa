class CreateDonatedItems < ActiveRecord::Migration[7.1]
  def change
    create_table :donated_items do |t|
      t.text :description
      t.string :item_type
      t.integer :value
      t.text :requirements
      t.string :status
      t.date :expiry_date
      t.string :donor_name
      t.text :internal_notes

      t.timestamps
    end
  end
end
