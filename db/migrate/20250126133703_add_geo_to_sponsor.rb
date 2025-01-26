class AddGeoToSponsor < ActiveRecord::Migration[7.0]
  def change
    add_column :sponsors, :expat_co, :string

  end
end
