class Equipment < ApplicationRecord
  belongs_to :netball_educator, optional: true #optional because it can be a quote

  validates :status, presence: true

  scope :quotes, -> { where(status: "Quote") }
  scope :sales,  -> { where(status: "Sale") }

  def quote?
    status == "Quote"
  end

  def sale?
    status == "Sale"
  end
  
end
