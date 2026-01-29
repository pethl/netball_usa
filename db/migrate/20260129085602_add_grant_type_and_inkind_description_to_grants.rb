class AddGrantTypeAndInkindDescriptionToGrants < ActiveRecord::Migration[7.1]
  def change
    add_column :grants, :grant_type, :string
    add_column :grants, :inkind_description, :text
  end
end