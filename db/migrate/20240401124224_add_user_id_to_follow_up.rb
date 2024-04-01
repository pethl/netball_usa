class AddUserIdToFollowUp < ActiveRecord::Migration[7.0]
  def change
    add_column :follow_ups, :user_id, :integer
  end
end
