class AddUserToPartners < ActiveRecord::Migration[7.2]


  def change
    add_reference :partners, :user, null: true, foreign_key: true
    add_column :partners, :old_user_id, :integer
  end
end
