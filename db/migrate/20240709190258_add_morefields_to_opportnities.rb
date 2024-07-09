class AddMorefieldsToOpportnities < ActiveRecord::Migration[7.0]
  def change
    add_column :opportunities, :outcome, :string
    add_column :opportunities, :outcome_date, :datetime
    add_column :opportunities, :outcome_received, :text
  end
end
