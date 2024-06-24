class CreateOpportunities < ActiveRecord::Migration[7.0]
  def change
    create_table :opportunities do |t|
      t.references :sponsor, index: true, foreign_key: true
      t.string :status
      t.references :user, index: true, foreign_key: true
      t.string :type
      t.string :website
      t.string :area
      t.text :pitch
      t.text :follow_up_actions
      t.text :notes

      t.timestamps
    end
  end
end
