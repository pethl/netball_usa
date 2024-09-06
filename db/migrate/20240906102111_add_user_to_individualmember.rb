class AddUserToIndividualmember < ActiveRecord::Migration[7.0]
  def change
    add_column :individual_members, :user_id, :integer
  end
end
