class AddLevelToNetballeducators < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :level, :string
  end
end
