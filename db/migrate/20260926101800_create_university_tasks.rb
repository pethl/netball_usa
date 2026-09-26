class CreateUniversityTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :university_tasks do |t|
      t.references :university_objective,
                   null: false,
                   foreign_key: true

      t.string :category, null: false
      t.text :action, null: false
      t.text :notes
      t.string :status, null: false, default: "Not Started"
      t.date :due_date
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
