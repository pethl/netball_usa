class CreateFollowUps < ActiveRecord::Migration[7.0]
  def change
    create_table :follow_ups do |t|
      t.string :lead_type
      t.string :status
      t.text :action_items
      t.decimal :sale_amount, precision: 7, scale: 2
      t.boolean :add_to_mailing_list
      t.integer :event_id
      t.string :netball_educator_id

      t.timestamps
    end
  end
end
