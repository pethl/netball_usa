class AddPersonIdToEquipment < ActiveRecord::Migration[7.0]
  def change
    add_column :equipment, :person_id, :integer
    add_foreign_key :equipment, :people, column: :person_id
    add_column :equipment, :sale_date, :datetime
  end
end
