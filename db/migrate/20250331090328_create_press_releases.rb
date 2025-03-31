class CreatePressReleases < ActiveRecord::Migration[7.2]
  def change
    create_table :press_releases do |t|
      t.string :media_announcement_link
      t.date :release_date
      t.string :title
      t.text :content
      t.references :medium, null: false, foreign_key: true

      t.timestamps
    end
  end
end
