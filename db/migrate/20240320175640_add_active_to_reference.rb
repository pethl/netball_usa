class AddActiveToReference < ActiveRecord::Migration[7.0]
  def change
    add_column :references, :active, :boolean
  end
end
