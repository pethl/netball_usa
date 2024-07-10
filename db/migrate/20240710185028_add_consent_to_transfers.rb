class AddConsentToTransfers < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :consent, :boolean
  end
end
