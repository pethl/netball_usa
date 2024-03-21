class CreateReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :references do |t|
      t.string :group
      t.string :value
      t.string :key
      t.string :desc

      t.timestamps
    end
  end
end
