class Vendor < ApplicationRecord
  has_many :reference_vendors
  has_many :references, through: :reference_vendors

  validates :company_name, presence: true
  validate :must_have_at_least_one_category
  
  private

  def must_have_at_least_one_category
    category_refs = references.select { |r| r.group == "vendor_category" }
    if category_refs.empty?
      errors.add(:references, "must include at least one category")
    end
  end

end
