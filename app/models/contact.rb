class Contact < ApplicationRecord
    belongs_to :sponsor

    validates :first_name, presence: true
    validates :last_name, presence: true

    scope :ordered, -> { order(last_name: :asc) }

    def full_name
        if self.prefix? && self.suffix?
            "#{self.prefix} #{self.first_name}  #{self.last_name}  #{self.suffix} "
        elsif self.prefix?
            "#{self.prefix} #{self.first_name}  #{self.last_name}"
        elsif self.suffix?
             "#{self.first_name}  #{self.last_name}  #{self.suffix} "
        else
            "#{self.first_name}  #{self.last_name}"
        end
    end
end
