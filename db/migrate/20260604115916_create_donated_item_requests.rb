class CreateDonatedItemRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :donated_item_requests do |t|
      t.references :donated_item, null: false, foreign_key: true
      t.references :requested_by, null: false, foreign_key: { to_table: :users }
      t.references :approved_by, null: true, foreign_key: { to_table: :users }
      t.text :purpose
      t.string :recipient_name
      t.string :recipient_phone
      t.string :delivery_method
      t.string :delivery_email
      t.string :delivery_name
      t.text :delivery_address
      t.date :date_needed_by
      t.string :status, default: "Pending", null: false
      t.text :admin_notes
      t.datetime :approved_at

      t.timestamps
    end
  end
end
