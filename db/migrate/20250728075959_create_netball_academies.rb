class CreateNetballAcademies < ActiveRecord::Migration[7.1]
  def change
    create_table :netball_academies do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :city
      t.string :us_state
      t.string :country
      t.references :club, null: true, foreign_key: true
      t.string :other_club_name
      t.string :status
      t.date :signed_up
      t.date :purchase_date
      t.string :subscribed_plans
      t.decimal :amount
      t.date :training_completed_date
      t.text :notes

      t.timestamps
    end
  end
end
