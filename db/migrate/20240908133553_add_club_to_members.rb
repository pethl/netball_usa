class AddClubToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :club_id, :integer
    add_foreign_key :members, :clubs, column: :club_id
  end
end
