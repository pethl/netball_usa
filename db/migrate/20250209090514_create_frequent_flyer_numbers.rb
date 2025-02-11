class CreateFrequentFlyerNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table :frequent_flyer_numbers do |t|
      t.references :person, null: false, foreign_key: true
      t.string :airline
      t.string :number

      t.timestamps
    end
  end
end
