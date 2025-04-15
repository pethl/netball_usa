class RenamePeopleIdToPersonIdInPrograms < ActiveRecord::Migration[7.1]
  def change
    rename_column :programs, :people_id, :person_id
  end
end
