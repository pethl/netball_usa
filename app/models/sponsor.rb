class Sponsor < ApplicationRecord
  
  belongs_to :user
  
  validates :sponsor_category, presence: true
  validates :industry, presence: true
  validates :company_name, presence: true, length: { maximum: 40 }
  validates :user_id, presence: true
 
end
