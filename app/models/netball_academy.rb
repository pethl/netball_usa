class NetballAcademy < ApplicationRecord
  belongs_to :club, optional: true

  scope :ordered, -> { order(signed_up: :desc) }

  def full_name
    name = [first_name, last_name].compact.join(' ').strip
    name.present? ? name : "(No name given)"
  end
end
