class Club < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :member_key_roles, dependent: :destroy
  has_many :individual_members
  has_many :payments
  has_many :teams
  has_many :notes, dependent: :destroy

  belongs_to(
    :creator,
    class_name: 'User',
    foreign_key: 'user_id',
    inverse_of: :clubs
  )

  before_create :titleize_fields
  before_validation :set_defaults

  # validations
  validates :name, presence: true
  validates :city, presence: true
  validates :us_state, presence: true 
  validates :membership_category, presence: true, on: :create
  validates :estimate_total_number_of_club_members, presence: true, on: :create
  validates :estimate_total_active_members, presence: true, on: :create
 # validates :estimate_total_part_time_members, presence: true, on: :create - not needed a defaulted

  scope :ordered, -> { order(name: :asc) }

  def renewed_for_year?(year = Date.today.year)
    (renewal_years || "").split(",").map(&:to_i).include?(year)
  end

  def key_roles_filled_count
    member_key_roles.distinct.count(:key_role)
  end

  def key_roles_status
    "#{key_roles_filled_count}/4"
  end

  def has_youth?
    Member.where(club_id: self.id, age_status: "Youth").any?
  end

  def has_paid
    year = ApplicationController.helpers.current_membership_year
    payments_for_year = payments.where(payment_year: year)

    if payments_for_year.any?
      total_amount = payments_for_year.sum(:amount)
      "$#{total_amount} paid"
    else
      "Payment Due"
    end
  end

  def club_president
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Club President").first
    if @member_key_role.blank?
      "Please nominate"
    else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
    end
  end

  def club_president_phone
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Club President").first
    if @member_key_role.blank?
      ""
    else
      @member = Member.find(@member_key_role.member_id)
      @member.phone
    end
  end

  def head_coach
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Head Coach").first
    if @member_key_role.blank?
      "Please nominate"
    else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
    end
  end

  def head_umpire
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Head Umpire").first
    if @member_key_role.blank?
      "Please nominate"
    else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
    end
  end

  def club_key_contact
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Club Key Contact").first
    if @member_key_role.blank?
      "Please nominate"
    else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
    end
  end

  def club_key_contact_phone
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Club Key Contact").first
    if @member_key_role.blank?
      ""
    else
      @member = Member.find(@member_key_role.member_id)
      @member.phone
    end
  end

  def club_payments_total
    year = ApplicationController.helpers.current_membership_year
    payments_for_year = payments.where(payment_year: year)
    payments_for_year.sum(:amount)
  end

  def club_payments_total_last_year
    last_year = ApplicationController.helpers.current_membership_year - 1
    payments_for_last_year = payments.where(payment_year: last_year)
    payments_for_last_year.sum(:amount)
  end

  def club_total_members
    members = Member.where(club_id: self.id).count
    individuals = IndividualMember.where(club_id: self.id).count
    members + individuals
  end

  def club_total_active_members
    members = Member.where(club_id: self.id, engagement_status: "Active").count
    individuals = IndividualMember.where(club_id: self.id, engagement_status: "Active").count
    members + individuals
  end

  def club_total_parttime_members
    members = Member.where(club_id: self.id, engagement_status: "Part-Time").count
    individuals = IndividualMember.where(club_id: self.id, engagement_status: "Part-Time").count
    members + individuals
  end

  def new_this_year?
    created_at.present? && created_at.year == Date.today.year
  end

  private

  def titleize_fields
    self.name = name.to_s.titleize if name.present?
    self.city = city.to_s.titleize if city.present?
  end

  def set_defaults
    self.estimate_total_part_time_members ||= 0
  end
end
