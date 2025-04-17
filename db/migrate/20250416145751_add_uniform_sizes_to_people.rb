class AddUniformSizesToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :inferno_bottom_skirt_size, :string
    add_column :people, :inferno_bottom_shorts_size, :string
    add_column :people, :inferno_top_polo_size, :string
    add_column :people, :inferno_top_vneck_size, :string
  end
end
