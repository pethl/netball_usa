class AddFkToMember < ActiveRecord::Migration[7.0]
  def change
    
    add_reference :na_teams, :member, index: true
  end
end
