class Grant < ApplicationRecord
  belongs_to :user
  before_save :normalize_purpose
  
  validates :name, presence: true
  validates :status, presence: true


def normalize_purpose
  self.purpose = purpose.strip if purpose.present?
end


end
