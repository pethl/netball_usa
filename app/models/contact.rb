class Contact < ApplicationRecord
    belongs_to :sponsor
    #belongs_to :partner, optional: true

    validates :first_name, presence: true
    validates :last_name, presence: true

    scope :ordered, -> { order(last_name: :asc) }

    def full_name
        parts = []
        parts << prefix if prefix.present?
        parts << first_name
        parts << last_name
        parts << suffix if suffix.present?
        parts.join(" ")
      end
      
end
