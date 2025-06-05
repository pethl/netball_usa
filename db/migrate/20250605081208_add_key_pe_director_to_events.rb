class AddKeyPeDirectorToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :key_pe_director_id, :uuid
  end
end
