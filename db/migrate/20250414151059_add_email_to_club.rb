class AddEmailToClub < ActiveRecord::Migration[7.1]
  def change
    add_column :clubs, :email, :string
  end
end
