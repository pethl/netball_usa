class AddUserLevelToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :level_submitted, :string
  end
end
