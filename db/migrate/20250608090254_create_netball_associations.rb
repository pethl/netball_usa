class CreateNetballAssociations < ActiveRecord::Migration[7.1]
  def change
    create_table :netball_associations do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.string :email
      t.string :website
      t.string :facebook
      t.string :twitter
      t.string :instagram
      t.text :notes
      t.references :user, null: false, foreign_key: true
      t.integer :number_of_clubs

      t.timestamps
    end
  end
end
