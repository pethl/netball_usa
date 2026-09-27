class CreateUserGroupMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :user_group_memberships do |t|
      t.references :user_group,
                   null: false,
                   foreign_key: true

      t.references :user,
                   null: false,
                   foreign_key: true

      t.timestamps
    end

    add_index :user_group_memberships,
              [:user_group_id, :user_id],
              unique: true,
              name: "index_user_group_memberships_uniquely"
  end
end
