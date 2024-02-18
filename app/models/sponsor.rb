class Sponsor < ApplicationRecord
  
  belongs_to :user
  
  validates :category, presence: true
  validates :industry, presence: true
  validates :company_name, presence: true, length: { maximum: 40 }
  validates :user_id, presence: true
 
end
