class AddImageFieldsToPeople < ActiveRecord::Migration[7.0]
  def change
    remove_column :people, :title, :text
    remove_column :people, :image_data, :text
    add_column :people, :description, :string
    add_column :people, :image, :text

  end
end
