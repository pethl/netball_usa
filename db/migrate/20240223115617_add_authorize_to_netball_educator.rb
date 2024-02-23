class AddAuthorizeToNetballEducator < ActiveRecord::Migration[7.0]
  def change
    add_column :netball_educators, :authorize, :boolean
  end
end
