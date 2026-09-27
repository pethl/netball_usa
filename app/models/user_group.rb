class UserGroup < ApplicationRecord
  has_many :user_group_memberships,
           dependent: :destroy

  has_many :users,
           through: :user_group_memberships

  validates :name, presence: true
  validates :key,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A[a-z0-9_]+\z/,
              message: "can only contain lowercase letters, numbers and underscores"
            }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }
end