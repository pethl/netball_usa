class AddEducatorIdToEquipment < ActiveRecord::Migration[7.0]
  def change
    add_column :equipment, :netball_educator_id, :uuid
    add_foreign_key :equipment, :netball_educators, column: :netball_educator_id
  end
end
