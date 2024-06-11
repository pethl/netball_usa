class AddPreviousUserToGrants < ActiveRecord::Migration[7.0]
  def change
    add_column :grants, :old_user_id, :integer
  end
end
