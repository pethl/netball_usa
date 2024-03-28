class CreateBudgets < ActiveRecord::Migration[7.0]
  def change
    create_table :budgets do |t|
      t.decimal :flight, precision: 7, scale: 2
      t.text :flight_notes
      t.decimal :hotel, precision: 7, scale: 2
      t.text :hotel_notes
      t.decimal :transport, precision: 7, scale: 2
      t.text :transport_notes
      t.decimal :shipping, precision: 7, scale: 2
      t.text :shipping_notes
      t.decimal :booth, precision: 7, scale: 2
      t.text :booth_notes
      t.decimal :carpet, precision: 7, scale: 2
      t.text :carpet_notes
      t.decimal :banners, precision: 7, scale: 2
      t.string :banner_notes
      t.decimal :giveaways, precision: 7, scale: 2
      t.text :giveaway_notes

      t.timestamps
    end
  end
end
