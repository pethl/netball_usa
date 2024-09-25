class AddClubToIndividualMember < ActiveRecord::Migration[7.0]
  def change
    add_column :individual_members, :club_id, :integer
    add_foreign_key :individual_members, :clubs, column: :club_id
  end
end
