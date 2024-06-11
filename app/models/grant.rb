class Grant < ApplicationRecord
  belongs_to :user
  before_save :send_allocation_email
  
  validates :name, presence: true
  validates :status, presence: true

  def send_allocation_email
    
    unless self.user_id == self.old_user_id
      GrantMailer.with(grant: self).record_allocation_notification.deliver_later
    end
  end
end
