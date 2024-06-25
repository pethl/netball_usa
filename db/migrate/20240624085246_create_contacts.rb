class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :prefix
      t.string :suffix
      t.string :nickname
      t.string :email
      t.string :phone
      t.string :linked_in
      t.string :job_title
      t.string :department
      t.string :organisation
      t.references :sponsor, index: true, foreign_key: true
      t.references :grant, index: true, foreign_key: true
      t.string :location
      t.text :notes

      t.timestamps
    end
  end
end
