class AddOldUserToOpportunity < ActiveRecord::Migration[7.0]
  def change
    add_column :opportunities, :old_user_id, :integer
  end
end
