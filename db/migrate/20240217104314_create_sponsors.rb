class CreateSponsors < ActiveRecord::Migration[7.0]
  def change
    create_table :sponsors do |t|
      t.string :category
      t.string :industry
      t.string :company_name
      t.string :status
      t.text :about
      t.string :location
      t.string :website
      t.text :key_contacts
      t.string :phone_numbers_emails
      t.string :opportunity_area
      t.string :pitch
      t.text :follow_up_actions
      t.text :notes

      t.timestamps
    end
  end
end
