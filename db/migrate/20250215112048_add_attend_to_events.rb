class AddAttendToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :attend, :string
  end
end
