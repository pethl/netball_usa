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

    validates :name, presence: true
    validates :city, presence: true
    validates :us_state, presence: true 

  scope :ordered, -> { order(name: :asc) }

  def has_youth?
    Member.where(club_id: self.id, age_status: "Youth").any?
  end

  def has_paid
    #clubs have annual membershp renewal on 30 june so special handling needed for year of payment. not required for individuals
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
    teams = Club.where(user_id: admin)
    payments_for_year = Payment.where(payment_year: year, club_id: teams)
    if payments_for_year.any?
      return payments_for_year.first.payment_summary
    else
      return "Payment Due"
    end
  end

  def team_president
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Team President").first
    if @member_key_role.blank?
       "Please nominate"
     else
      @member = Member.find(@member_key_role.member_id)
      @member.full_name
    end
  end

  def team_president_phone
    @member_key_role = MemberKeyRole.where(club_id: self.id, key_role: "Team President").first
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

  def club_payments_total
    total=0
    arr = self.payments
    arr.each {|x| total=total+x[:amount]}
    return total
  end

  def club_total_members
    members = Member.where(club_id: self.id).count
    individuals = IndividualMember.where(club_id: self.id).count
   return members+individuals
  end

  def club_total_active_members
    members = Member.where(club_id: self.id, engagement_status: "Active").count
    individuals = IndividualMember.where(club_id: self.id, engagement_status: "Active").count
    return members+individuals
  end

  def club_total_parttime_members
    members = Member.where(club_id: self.id, engagement_status: "Part-Time").count
    individuals = IndividualMember.where(club_id: self.id, engagement_status: "Part-Time").count
    return members+individuals
  end
 
end
