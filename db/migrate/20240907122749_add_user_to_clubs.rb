class AddUserToClubs < ActiveRecord::Migration[7.0]
  def change
    add_column :clubs, :user_id, :integer
    add_foreign_key :clubs, :users, column: :user_id
  end
end
