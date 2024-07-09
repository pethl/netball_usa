class AddEngagementStatusToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :engagement_status, :string
  end
end
