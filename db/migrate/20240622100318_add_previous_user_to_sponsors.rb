class AddPreviousUserToSponsors < ActiveRecord::Migration[7.0]
  def change
    add_column :sponsors, :old_user_id, :integer
  end
end
