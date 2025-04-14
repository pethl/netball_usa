class AddReleaseDateToMedia < ActiveRecord::Migration[7.1]
  def change
    add_column :media, :release_date, :date
  end
end
