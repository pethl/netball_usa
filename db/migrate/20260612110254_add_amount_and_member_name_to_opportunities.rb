class AddAmountAndMemberNameToOpportunities < ActiveRecord::Migration[7.1]
  def change
    add_column :opportunities, :amount, :integer
    add_column :opportunities, :member_name, :string
  end
end
