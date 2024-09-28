class Payment < ApplicationRecord
    belongs_to :IndividualMember, optional: true
    belongs_to :Club, optional: true

    validates :payment_year, presence: true
    validates :payment_type, presence: true
    #validates :amount, presence: true
   # validates :payment_received_date, presence: true

   def payment_summary
     "#{self.payment_type} $#{self.amount} #{self.payment_received_date.to_formatted_s(:usa)}"
   end
end 
