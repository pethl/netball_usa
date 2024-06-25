class AddContactToOpportunity < ActiveRecord::Migration[7.0]
  def change
    add_column :opportunities, :contact_id, :integer
  end
end
