class CreateNotes < ActiveRecord::Migration[7.2]
  def change
    create_table :notes do |t|
      t.text :body
      t.references :club, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
