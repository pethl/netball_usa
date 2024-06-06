class AddResourcesToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_reference :transfers, :event, foreign_key: true
    add_reference :transfers, :person, foreign_key: true
  end
end
