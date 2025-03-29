class Medium < ApplicationRecord
  belongs_to :user

  validates :media_type, presence: true
  validates :company_name, presence: true

  scope :ordered, -> { order(company_name: :asc) }
  scope :published, -> { where.not(media_announcement_link: [nil, ""]).where.not(release_date: nil) }

end
