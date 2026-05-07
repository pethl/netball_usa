class AddPartnerGroupToNetballEducators < ActiveRecord::Migration[7.1]
  def change
    add_column :netball_educators, :partner_group, :string
  end
end
