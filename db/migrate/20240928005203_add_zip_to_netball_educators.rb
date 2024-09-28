class AddZipToNetballEducators < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :zip, :string
    add_column :netball_educators, :is_pe_director, :boolean
  end
end
