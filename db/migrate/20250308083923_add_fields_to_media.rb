class AddFieldsToMedia < ActiveRecord::Migration[7.2]
  def change
    add_column :media, :company_website, :string
    add_column :media, :socials, :string
    add_column :media, :notes, :text
    add_column :media, :user_id, :integer
    add_column :media, :old_user_id, :integer
  end
end
