class AddTitleToNetballEducators < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :title, :string
  end
end
