class AddNotesToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :admin_notes, :text
  end
end
