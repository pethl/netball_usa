class Sponsor < ApplicationRecord
  
  belongs_to :user
  before_save :send_allocation_email
  
  validates :sponsor_category, presence: true
  validates :industry, presence: true
  validates :company_name, presence: true, length: { maximum: 40 }
  validates :user_id, presence: true
 

  def send_allocation_email
    
    unless self.user_id == self.old_user_id
      SponsorMailer.with(sponsor: self).record_allocation_notification.deliver_later
    end
  end
end
