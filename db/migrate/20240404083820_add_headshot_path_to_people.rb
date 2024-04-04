class AddHeadshotPathToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :headshot_path, :string
  end
end
