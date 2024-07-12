class NaTeam < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :member_key_roles, dependent: :destroy
  has_many :payments
  
  belongs_to(
    :creator,
    class_name: 'User',
    foreign_key: 'user_id',
    inverse_of: :na_teams
  )
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
 
  scope :ordered, -> { order(name: :asc) }
  #scope :ordered, -> { order(name: :asc) }
  
  def region_name
    Region.where(state: self.state).first.region
  end
  
  def members?
    members.any?
  end

  def has_youth?
    Member.where(na_team_id: self.id, age_status: "Youth").any?
  end
  
  def team_president
    @member_key_role = MemberKeyRole.where(na_team_id: self.id, key_role: "Team President").first
    if @member_key_role.blank?
       "Please nominate"
     else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
    end
  end
  
  def head_coach
    @member_key_role = MemberKeyRole.where(na_team_id: self.id, key_role: "Head Coach").first
    if @member_key_role.blank?
       "Please nominate"
     else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
      end
  end
  
  def head_umpire
    @member_key_role = MemberKeyRole.where(na_team_id: self.id, key_role: "Head Umpire").first
    if @member_key_role.blank?
       "Please nominate"
     else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
    end
  end

  def has_paid
    #na_teams have annual membershp renewal on 30 june so special handling needed for year of payment. not required for individuals
    #first set the renewal date - 30 June 
    year = (Date.today.year)
    start_date =  DateTime.new(year, 06, 30, 00, 00, 0) 

    #check if current date is in this renewal year or last year, by seeing if before or after June 30
    if Date.today < start_date
     
      year = year-1
    else
      year = Date.today.year
    end
    
    admin = self.user_id
    teams = NaTeam.where(user_id: admin)
    payments_for_year = Payment.where(payment_year: year, na_team_id: teams)
    if payments_for_year.any?
      return payments_for_year.first.payment_summary
    else
      return "Payment Due"
    end
  end
end

