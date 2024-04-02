class AddAcceptNotesToPerson < ActiveRecord::Migration[7.0]
  def change
         add_column :people, :accept_notes, :text
  end
end
