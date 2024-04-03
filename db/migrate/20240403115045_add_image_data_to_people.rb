class AddImageDataToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :image_data, :text
  end
end
