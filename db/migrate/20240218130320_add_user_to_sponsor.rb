class AddUserToSponsor < ActiveRecord::Migration[7.0]
  def change
    add_column :sponsors, :user_id, :integer
  end
end
