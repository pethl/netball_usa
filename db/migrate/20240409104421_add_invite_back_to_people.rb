class AddInviteBackToPeople < ActiveRecord::Migration[7.0]
  def change
       remove_column :people, :invite_back, :boolean
       add_column :people, :invite_back, :string
  end
end
