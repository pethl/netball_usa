class CreateUmpires < ActiveRecord::Migration[7.0]
  def change
    create_table :umpires do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :region
      t.string :location
      t.string :email
      t.string :level
      t.string :phone
      t.string :address
      t.string :associated
      t.string :gender
      t.string :tshirt_size
      t.string :uniform_size
      t.boolean :headshot
      t.string :headshot_file
      t.boolean :invite_back
      t.text :notes

      t.timestamps
    end
  end
end
