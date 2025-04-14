class ChangePersonIdNullOnEventParticipants < ActiveRecord::Migration[7.1]
  def change
    change_column_null :event_participants, :person_id, true
  end
end
