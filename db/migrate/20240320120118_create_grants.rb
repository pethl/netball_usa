class CreateGrants < ActiveRecord::Migration[7.0]
  def change
    create_table :grants do |t|
      t.string :name
      t.boolean :apply
      t.integer :amount
      t.string :location
      t.datetime :due_date
      t.text :purpose
      t.string :grant_link
      t.text :notes
      t.string :status
      t.datetime :date_submitted
      t.string :program
      t.string :application_link
      t.string :login

      t.timestamps
    end
  end
end
