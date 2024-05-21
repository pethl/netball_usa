class CreateMemberKeyRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :member_key_roles do |t|
      t.references :team, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: true
      t.string :key_role

      t.timestamps
    end
  end
end
