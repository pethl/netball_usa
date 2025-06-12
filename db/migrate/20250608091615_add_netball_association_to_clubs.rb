class AddNetballAssociationToClubs < ActiveRecord::Migration[7.1]
  def change
    add_reference :clubs, :netball_association, null: true, foreign_key: true
  end
end
