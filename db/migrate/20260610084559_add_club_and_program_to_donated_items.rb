class AddClubAndProgramToDonatedItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :donated_items, :club, null: true, foreign_key: true
    add_reference :donated_items, :program, null: true, foreign_key: true
  end
end
