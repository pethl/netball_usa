class AddMgmtNotesToOpportunities < ActiveRecord::Migration[7.2]
  def change
    add_column :opportunities, :in_progress_status, :text
  end
end
