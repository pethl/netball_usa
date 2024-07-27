class AddSubmittedToOpportunity < ActiveRecord::Migration[7.0]
  def change
    add_column :opportunities, :date_submitted, :datetime
  end
end
