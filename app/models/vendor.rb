class Vendor < ApplicationRecord
  has_many :reference_vendors
  has_many :references, through: :reference_vendors
end
