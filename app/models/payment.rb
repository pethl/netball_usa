class Payment < ApplicationRecord
    belongs_to :individual_member, optional: true
    belongs_to :club, optional: true
    belongs_to :payment_recorded_by, class_name: 'User', optional: true

    validate :individual_or_club_presence
    validates :payment_year, presence: true
    validates :payment_type, presence: true


    #validates :amount, presence: true
   # validates :payment_received_date, presence: true

   def payment_summary
     "#{self.payment_type} $#{self.amount} #{self.payment_received_date.to_formatted_s(:usa)}"
   end

   def individual_or_club_presence
    if individual_member_id.blank? && club_id.blank?
      errors.add(:base, "Must link to either an individual member or a club")
    elsif individual_member_id.present? && club_id.present?
      errors.add(:base, "Cannot link to both individual member and club")
    end
  end
end 
