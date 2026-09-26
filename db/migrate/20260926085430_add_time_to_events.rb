class AddTimeToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :time, :string
  end
end
