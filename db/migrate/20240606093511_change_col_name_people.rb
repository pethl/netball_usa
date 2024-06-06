class ChangeColNamePeople < ActiveRecord::Migration[7.0]
  def change
    rename_column :people, :headshot, :headshot_present
  end
end
