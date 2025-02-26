class AddLinksToSponsor < ActiveRecord::Migration[7.2]
  def change
    add_column :sponsors, :other_link, :string
    add_column :sponsors, :other_locations, :string
  end
end
