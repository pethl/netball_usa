class AddFieldsToBudget < ActiveRecord::Migration[7.0]
  def change
    add_column :budgets, :per_diem, :decimal, precision: 7, scale: 2
    add_column :budgets, :number_of_people, :integer
    add_column :budgets, :number_of_days, :decimal, precision: 7, scale: 2
  end
end
