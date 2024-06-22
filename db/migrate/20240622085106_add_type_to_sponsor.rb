class AddTypeToSponsor < ActiveRecord::Migration[7.0]
  def change
    add_column :sponsors, :sponsor_type, :string
  end
end
