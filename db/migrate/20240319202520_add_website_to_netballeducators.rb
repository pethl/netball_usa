class AddWebsiteToNetballeducators < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :website, :string
  end
end
