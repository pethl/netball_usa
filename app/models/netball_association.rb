class NetballAssociation < ApplicationRecord
  belongs_to :user
  has_many :clubs, dependent: :nullify

  validates :name, :user_id, presence: true
  validates :name, :city, :state, presence: true

  scope :ordered, -> { order(:name) }
end
