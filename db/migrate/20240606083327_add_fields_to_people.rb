class AddFieldsToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :certification_date, :datetime
    add_column :people, :headshot_data, :text
    add_column :people, :certification_data, :text 
  end
end
