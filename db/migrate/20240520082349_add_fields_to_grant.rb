class AddFieldsToGrant < ActiveRecord::Migration[7.0]
  def change
    add_column :grants, :action_by, :datetime
    add_column :grants, :state, :string
  end
end
