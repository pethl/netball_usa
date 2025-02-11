class CreateMedia < ActiveRecord::Migration[7.0]
  def change
    create_table :media do |t|
      t.string :media_type
      t.string :company_name
      t.string :contact_name
      t.string :contact_position
      t.string :email
      t.string :phone
      t.string :city
      t.string :state
      t.string :country
      t.text :pitch
      t.string :media_announcement_link

      t.timestamps
    end
  end
end
