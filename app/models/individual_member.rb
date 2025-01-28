class IndividualMember < ApplicationRecord
  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :club, optional: true
  has_many :payments
    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :city, presence: true
  validate :state_or_country
  validates :gender, presence: true
  validates :age_status, presence: true
  validates :engagement_status, presence: true
  validates :membership_type, presence: true
  
  scope :ordered, -> { order(first_name: :asc) }
  
  def full_name
    [first_name, last_name].compact.join(" ")
  end
  
  def has_paid
    year = Date.today.year 
    payments_for_year = Payment.where(payment_year: year, individual_member_id: self)

    if self.discount_code =="AT25NET"
      return "Discounted Member"
    elsif payments_for_year.any?
      return payments_for_year.sum(:amount)
    else
      return "Payment Due"
    end
  end

  private

  def state_or_country
    if state.blank? && country.blank?
      errors.add(:base, "Either state or country must be provided")
    end
  end

end
