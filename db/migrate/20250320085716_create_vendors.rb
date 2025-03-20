class CreateVendors < ActiveRecord::Migration[7.2]
  def change
    create_table :vendors do |t|
      t.string :company_name
      t.string :contact_name
      t.string :email
      t.string :phone
      t.string :website
      t.text :notes

      t.timestamps
    end
  end
end
