class AddUserToEducator < ActiveRecord::Migration[7.0]
  def change
     add_column :educators, :user_id, :integer
  end
end
