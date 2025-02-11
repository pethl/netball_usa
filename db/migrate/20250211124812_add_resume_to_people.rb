class AddResumeToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :resume_data, :text
  end
end
