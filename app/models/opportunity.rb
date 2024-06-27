class Opportunity < ApplicationRecord
    belongs_to :sponsor
    before_save :send_allocation_email

    scope :ordered, -> { order(created_at: :asc) }

    def send_allocation_email
      if self.old_user_id.blank?
      else
        unless self.user_id == self.old_user_id
          OpportunityMailer.with(opportunity: self).record_allocation_notification.deliver_later
        end
      end
    end
   end
