class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.integer :payment_year
      t.string :payment_type
      t.references :na_team, foreign_key: true
      t.references :individual_member, foreign_key: true
      t.references :payment_recorded_by, foreign_key: {to_table: :users}
      t.datetime :payment_received_date
      t.string :payment_transaction_reference
      t.text :payment_notes

      t.timestamps
    end
  end
end
