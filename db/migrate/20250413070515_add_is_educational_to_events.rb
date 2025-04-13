class AddIsEducationalToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :is_educational, :string, default: "No"
  end
end
