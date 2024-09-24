class AddClubToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :club_id, :integer
    add_foreign_key :payments, :clubs, column: :club_id
  end
end
