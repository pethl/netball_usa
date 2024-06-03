class AddMoreFieldsToTransfer < ActiveRecord::Migration[7.0]
  def change
    add_column :transfers, :umpire_badge_level, :string
    add_column :transfers, :certification_date, :datetime
    add_column :transfers, :visa_type, :string
    add_column :transfers, :t_shirt_size, :string
  end
end
