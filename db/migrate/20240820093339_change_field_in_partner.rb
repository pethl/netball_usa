class ChangeFieldInPartner < ActiveRecord::Migration[7.0]
  def change
    remove_column :partners, :state, :string
    add_column :partners, :us_state, :string
  end
end
