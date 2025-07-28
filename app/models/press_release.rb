class PressRelease < ApplicationRecord
  belongs_to :medium

  validate :release_date_required_if_link_present

  scope :published, -> {
    where.not(media_announcement_link: [nil, ""])
    .where.not(release_date: nil)
  }


  private

  def release_date_required_if_link_present
    if media_announcement_link.present? && release_date.blank?
      errors.add(:release_date, "must be provided if you add a media announcement link.")
    end
  end
end
