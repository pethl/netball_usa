class AddEventIDtoBudget < ActiveRecord::Migration[7.0]
  def change
    add_column :budgets, :event_id, :integer
  end
end
