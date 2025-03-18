class AddSocialsToMedia < ActiveRecord::Migration[7.2]
  def change
    add_column :media, :contact_email, :string
    add_column :media, :facebook, :string
    add_column :media, :twitter, :string
    add_column :media, :instagram, :string
    add_column :media, :event_calender_link, :string
    add_column :media, :calendar_login_details, :string
  end
end
 