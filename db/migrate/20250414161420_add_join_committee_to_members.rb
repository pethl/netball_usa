class AddJoinCommitteeToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :join_a_committee, :boolean
  end
end
