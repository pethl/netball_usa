class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable,  :confirmable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
         
  validates :first_name, :last_name, presence: true
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
end
