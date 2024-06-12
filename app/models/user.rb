class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :trackable
         
  validates :first_name, :last_name, presence: true
  after_create :send_admin_mail
  
  has_many(
    :na_teams,
    class_name: 'NaTeam',
    foreign_key: 'user_id',
    inverse_of: :creator
  )
  
  #enum role: [:admin, :office, :teamlead]
  enum role: {
    admin: 0,
    teams_grants: 1,
    teamlead: 2,
    grants: 3,
    educators: 4 
  }

  # User::Roles
  # The available roles
  Roles = [ :admin , :teams_grants, :grants, :teamlead, :educators  ]
  after_initialize :set_default_role, :if => :new_record?
  
  def set_default_role
    self.role || :teamlead
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
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

  def educators?
    self.role == 'educators'
  end
 
#  def active_for_authentication? 
#    super && approved?
#  end 
  
#  def inactive_message 
#    approved? ? super : :not_approved
#  end
  
  def send_admin_mail
    ApplicationMailer.new_user_waiting_for_approval(email).deliver
  end
  
end
