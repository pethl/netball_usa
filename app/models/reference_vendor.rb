class ReferenceVendor < ApplicationRecord
  belongs_to :vendor
  belongs_to :reference
end
