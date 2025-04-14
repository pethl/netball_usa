class AddNetballEducatorIdToEventParticipants < ActiveRecord::Migration[7.1]
  def change
    # Add the new netball_educator_id column (as UUID not bigint!)
    add_column :event_participants, :netball_educator_id, :uuid

    # Add the index for netball_educator_id
    add_index :event_participants, :netball_educator_id

    # Add a unique index for the combination of event_id and netball_educator_id
    add_index :event_participants, [:event_id, :netball_educator_id], unique: true, name: 'index_event_participants_on_event_and_netball_educator'
  end
end
