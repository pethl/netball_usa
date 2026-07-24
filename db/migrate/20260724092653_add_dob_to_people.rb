class AddDobToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :dob, :date
  end
end
