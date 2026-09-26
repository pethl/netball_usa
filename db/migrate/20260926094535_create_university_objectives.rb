class CreateUniversityObjectives < ActiveRecord::Migration[7.1]
  def change
    create_table :university_objectives do |t|
      t.string :timeframe, null: false
      t.string :title, null: false
      t.text :description
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

  end
end
