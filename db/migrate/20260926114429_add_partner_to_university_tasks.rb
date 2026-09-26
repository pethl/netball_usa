class AddPartnerToUniversityTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :university_tasks,
                  :partner,
                  null: true,
                  foreign_key: true
  end
end
