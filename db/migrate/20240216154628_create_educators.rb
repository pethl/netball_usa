class CreateEducators < ActiveRecord::Migration[7.0]
  def change
    create_table :educators do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :school_name
      t.string :city
      t.string :state
      t.text :educator_notes
      t.text :mgmt_notes

      t.timestamps
    end
  end
end
