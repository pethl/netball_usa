class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable,  :confirmable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
         
  validates :first_name, :last_name, presence: true
  after_create :send_admin_mail
  
  has_many(
    :teams,
    class_name: 'Team',
    foreign_key: 'user_id',
    inverse_of: :creator
  )
  
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def active_for_authentication? 
    super && approved?
  end 
  
  def inactive_message 
    approved? ? super : :not_approved
  end
  
  def send_admin_mail
    ApplicationMailer.new_user_waiting_for_approval(email).deliver
  end
  
end
