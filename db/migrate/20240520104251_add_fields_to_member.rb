class AddFieldsToMember < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :age_status, :string
  end
end
