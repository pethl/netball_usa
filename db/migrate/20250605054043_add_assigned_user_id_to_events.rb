class AddAssignedUserIdToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :assigned_user_id, :integer
  end
end
