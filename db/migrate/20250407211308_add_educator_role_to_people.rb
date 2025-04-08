class AddEducatorRoleToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :educator_role, :string
  end
end
