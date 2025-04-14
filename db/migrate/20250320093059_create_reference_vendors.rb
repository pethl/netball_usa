class CreateReferenceVendors < ActiveRecord::Migration[7.1]
  def change
    create_table :reference_vendors do |t|
      t.references :vendor, null: false, foreign_key: true
      t.references :reference, null: false, foreign_key: true

      t.timestamps
    end
  end
end
