class AddUserToNetballEducator < ActiveRecord::Migration[7.0]
  def change
     add_column :netball_educators, :user_id, :integer
  end
end
