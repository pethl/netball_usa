class Medium < ApplicationRecord
  belongs_to :user
  has_many :press_releases, dependent: :destroy
  accepts_nested_attributes_for :press_releases, allow_destroy: true


  validates :media_type, presence: true
  validates :company_name, presence: true

  scope :ordered, -> { order(company_name: :asc) }
  scope :published, -> { where.not(media_announcement_link: [nil, ""]).where.not(release_date: nil) }

end
