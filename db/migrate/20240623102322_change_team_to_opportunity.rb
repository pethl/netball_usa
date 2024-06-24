class ChangeTeamToOpportunity < ActiveRecord::Migration[7.0]
  def change
    rename_column :opportunities, :type, :opportunity_type
  end
end
