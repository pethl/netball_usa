class AddPartnersToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :partner_id, :integer
  end
end
