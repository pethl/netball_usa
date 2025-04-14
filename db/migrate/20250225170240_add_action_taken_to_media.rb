class AddActionTakenToMedia < ActiveRecord::Migration[7.1]
  def change
    add_column :media, :action_taken, :text
    add_column :media, :region_other, :string
  end
end
