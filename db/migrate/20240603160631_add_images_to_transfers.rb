class AddImagesToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :headshot_data, :text
    add_column :transfers, :certification_data, :text
  end
end
