class AddContactsToPartners < ActiveRecord::Migration[7.0]
  def change
    add_column :partners, :first_name_primary, :string
    add_column :partners, :last_name_primary, :string
    add_column :partners, :role_primary, :string
    add_column :partners, :email_primary, :string
    add_column :partners, :cell_primary, :string
    add_column :partners, :work_phone_primary, :string
    add_column :partners, :first_name_secondary, :string
    add_column :partners, :last_name_secondary, :string
    add_column :partners, :role_secondary, :string
    add_column :partners, :email_secondary, :string
    add_column :partners, :cell_secondary, :string
    add_column :partners, :work_phone_secondary, :string
    add_column :partners, :first_name_third, :string
    add_column :partners, :last_name_third, :string
    add_column :partners, :role_third, :string
    add_column :partners, :email_third, :string
    add_column :partners, :cell_third, :string
    add_column :partners, :work_phone_third, :string

  end
end
