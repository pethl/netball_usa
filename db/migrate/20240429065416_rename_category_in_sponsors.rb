class RenameCategoryInSponsors < ActiveRecord::Migration[7.0]
  def change
    rename_column :sponsors, :category, :sponsor_category
  end
end
