class CreateOpenInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :open_invites do |t|
      t.string :status
      t.boolean :invite_sent
      t.date :invite_sent_date
      t.boolean :rspv
      t.boolean :whova
      t.boolean :flight_booked
      t.boolean :sent_save_the_date
      t.boolean :response_to_save_the_date
      t.boolean :send_official_invite
      t.text :comments
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
