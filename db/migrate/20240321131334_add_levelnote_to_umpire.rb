class AddLevelnoteToUmpire < ActiveRecord::Migration[7.0]
  def change
     add_column :umpires, :level_note, :string
  end
end
