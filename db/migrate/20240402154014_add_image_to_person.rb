class AddImageToPerson < ActiveRecord::Migration[7.0]
  def change
    remove_column :people, :headshot_file, :string
    add_column :people, :title, :text
    add_column :people, :image_data, :text
  end
end
