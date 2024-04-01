class AddFieldsToPerson < ActiveRecord::Migration[7.0]
  def change
     add_column :people, :in_person_trained, :boolean
     add_column :people, :virtually_trained, :boolean
     add_column :people, :booth_trained, :boolean
  end
end
