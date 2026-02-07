class CreateFilingOccurrences < ActiveRecord::Migration[7.1]
  def change
    create_table :filing_occurrences do |t|
      t.references :filing,
        null: false,
        foreign_key: { on_delete: :restrict }
    
      t.date    :due_date, null: false
      t.boolean :filed, default: false
      t.date    :filed_at
    
      t.decimal :cost, precision: 10, scale: 2
      t.boolean :generated, default: true, null: false
    
      t.timestamps
    end
    
    add_index :filing_occurrences,
      [:filing_id, :due_date],
      unique: true
    
    
  end
end
