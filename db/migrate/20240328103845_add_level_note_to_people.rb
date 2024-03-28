class AddLevelNoteToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :level_note, :string
  end
end
