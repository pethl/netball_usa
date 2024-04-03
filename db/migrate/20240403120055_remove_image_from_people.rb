class RemoveImageFromPeople < ActiveRecord::Migration[7.0]
  def change
    remove_column :people, :image
  end
end
