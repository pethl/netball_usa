class IndividualMember < ApplicationRecord
  before_save :downcase_email
  belongs_to :user
  belongs_to :team, optional: true
  belongs_to :club, optional: true
  has_many :payments
    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :membership_type, presence: true
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

  
  scope :ordered, -> { order(first_name: :asc) }
  
  def full_name
    [first_name, last_name].compact.join(" ")
  end
  
  def has_paid
    year = ApplicationController.helpers.current_membership_year
    payments_for_year = Payment.where(payment_year: year, individual_member_id: id)
  
    if discount_code == "AT25NET"
      "Discounted Member"
    elsif payments_for_year.any?
      "$#{payments_for_year.sum(:amount)} "
    else
      "Payment Due"
    end
  end

  def new_member_this_year?
    created_at.year == Date.today.year
  end

  private

  def state_or_country
    if state.blank? && country.blank?
      errors.add(:base, "Either state or country must be provided")
    end
  end

  def downcase_email
    self.email = email.downcase if email.present?
  end

end
