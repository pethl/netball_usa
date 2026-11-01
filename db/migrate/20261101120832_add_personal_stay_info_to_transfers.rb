class AddPersonalStayInfoToTransfers < ActiveRecord::Migration[7.1]
  def change
    add_column :transfers, :personal_stay_info, :text
  end
end
