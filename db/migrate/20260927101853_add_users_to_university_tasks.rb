class AddUsersToUniversityTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :university_tasks,
                  :assigned_user,
                  foreign_key: { to_table: :users },
                  null: true

    add_reference :university_tasks,
                  :created_by,
                  foreign_key: { to_table: :users },
                  null: true

    add_reference :university_tasks,
                  :updated_by,
                  foreign_key: { to_table: :users },
                  null: true
  end
end
