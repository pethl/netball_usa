class AddNotificationToGrants < ActiveRecord::Migration[7.0]
  def change
    add_column :grants, :notification_date, :datetime
  end
end
