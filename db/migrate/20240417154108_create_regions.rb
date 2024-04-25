class CreateRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|
      t.string :state
      t.string :region

      t.timestamps
    end
  end
end
