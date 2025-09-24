class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :validatable, :trackable #,:confirmable,

  before_create :skip_confirmation!
         
  validates :first_name, :last_name, presence: true
  after_create :send_admin_alert
  after_create :send_sonya_mail

  # app/models/user.rb
  scope :active_admins, -> { where(account_active: true)
  .where.not(role: [2, 12])
  .where.not(last_name: 'Pethick')
  .order(:first_name) }

  #special group for educators  - sonya
  scope :active_educator_users, -> {
    where(account_active: true)
      .where.not(last_name: "Pethick")
      .where("(role IN (?) OR last_name = ?)", [4, 8, 10], "Ottaway")
      .order(:first_name)
  }

  
  has_many(
    :na_teams,
    class_name: 'NaTeam',
    foreign_key: 'user_id',
    inverse_of: :creator
  )

  has_many :opportunities
  has_many :media

  has_many :events, foreign_key: :assigned_user_id
  has_one :netball_association, class_name: "NetballAssociation"

  has_many(
    :clubs,
    class_name: 'Club',
    foreign_key: 'user_id',
    inverse_of: :creator
  )
  
  #enum role: [:admin, :office, :teamlead]
  enum :role, {:admin=>0, 
  :teams_grants=>1, 
  :teamlead=>2, 
  :grants=>3, 
  :no_access=>4, 
  :teams_admin=>5, 
  :sponsors_events=>6, 
  :us_open=>7,
  :educators_events=>8, 
  :sponsors_media_events=>9, 
  :educators_events_medium=>10,
  :spare=>11,
  :na_people=>12}

  # User::Roles
  # The available roles
  Roles = [:admin, :teams_grants, :teamlead, :grants, :educators, :teams_admin, 
           :sponsors_events, :us_open, :educators_events, :sponsors_media_events, 
           :educators_events_medium, :spare, :na_people]
  after_initialize :set_default_role, :if => :new_record?
  
  def set_default_role
    self.role ||= :teamlead  # only if nil
  end

  def send_reset_password_instructions
    if account_active?
      super
    else
      # Simulate Devise behavior: return a dummy user object with errors
      self.errors.add(:base, "Your account is inactive. Contact support.")
      self
    end
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def initials
    first_initial = first_name.present? ? first_name[0].upcase : ""
    last_initial = last_name.present? ? last_name[0].upcase : ""
    "#{first_initial}#{last_initial}"
  end
  
  def teams_grants?
    self.role == 'teams_grants'
  end

  def grants?
    self.role == 'grants'
  end

  def teamlead?
    self.role == 'teamlead'
  end

  def no_access?
    self.role == 'no_access'
  end

  def teams_admin?
    self.role == 'teams_admin'
  end

  def sponsors_events?
    self.role == 'sponsors_events'
  end

  def us_open?
    self.role == 'us_open'
  end

  def educators_events?
    self.role == 'educators_events'
  end

  def sponsors_media_events?
     self.role == 'sponsors_media_events'
  end

  def educators_events_medium?
     self.role == 'educators_events_medium'
  end

  def na_people?
    self.role == 'na_people'
 end
  
 
#  def active_for_authentication? 
#    super && approved?
#  end 
  
#  def inactive_message 
#    approved? ? super : :not_approved
#  end
  
  def active_for_authentication?
    # Uncomment the below debug statement to view the properties of the returned self model values.
    # logger.debug self.to_yaml
      
    super && account_active?
  end

  def inactive_message
    account_active? ? super : :account_inactive
  end

  def send_admin_alert
    # originally intended for users needed approval, approval switched off so left for alerting security
    UserMailer.admin_new_user_alert(self).deliver_later
  end

  def send_sonya_mail
    # email to advise Sonya / info@netballamerica.com that a new user has registered, most are club admins
    UserMailer.new_team_sign_up(email).deliver
  end

  private
  def skip_confirmation!
    self.confirmed_at ||= Time.current
  end
  
end
