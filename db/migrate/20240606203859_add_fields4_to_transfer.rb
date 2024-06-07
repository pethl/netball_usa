class AddFields4ToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :event_title, :string
    add_column :transfers, :registration_form_completed, :boolean
    add_column :transfers, :waiver_form_completed, :boolean
    add_column :transfers, :read_and_agreed_tcs, :boolean
  end
end
