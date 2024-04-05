class AddPhoneToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :phone, :string
  end
end
