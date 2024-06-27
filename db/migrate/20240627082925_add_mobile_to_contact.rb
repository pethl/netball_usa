class AddMobileToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :mobile, :string
  end
end
