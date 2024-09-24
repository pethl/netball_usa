class AddPhoneToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :phone, :string
  end
end
