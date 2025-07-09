class Event < ApplicationRecord
  belongs_to :assigned_user, class_name: "User", optional: true
  belongs_to :key_pe_director, class_name: "NetballEducator", optional: true
  has_many :event_participants, dependent: :destroy
  has_many :people, through: :event_participants
  has_many :netball_educators, through: :event_participants
  has_many :event_assignments, dependent: :destroy
 # has_many :transfers, through: :event_assignments
  has_many :transfers
  has_one :budget #, dependent: :destroy
  
  # for user assignment
  before_save :track_old_assigned_user
  after_save :send_allocation_email, if: :assigned_user_saved_change_and_not_self?
  attr_accessor :old_assigned_user_id
  # end 
   
  validates :event_type, presence: true
  validates :name, presence: true

  scope :ordered, -> { order(date: :asc) }
  scope :ordered_desc, -> { order(date: :desc) }

  # New scope for educational events
  scope :educational, -> { where(is_educational: 'Yes') } 
  scope :upcoming, -> { where('date >= ?', Date.today.beginning_of_month).order(date: :asc) }
  scope :past,     -> { where('date < ?', Date.today.beginning_of_month).order(date: :desc) }
  scope :gone,     -> { where('date < ?', Date.today).order(date: :desc) }

  
  def budget_count
    budget.present? ? [budget] : 0
  end
  
  def event_date_name
   "#{self.event_date_formatted}, #{self.name} "
  end

  def event_date_type_name
    "#{self.event_date_formatted}, #{self.event_type}:  #{self.name} "
  end

  def event_date_state_type_name
  "#{self.event_date_formatted} : #{self.state} : #{self.event_type} -  #{self.name} "
  end

  def event_date_state_name
    "#{self.event_date_formatted} : #{self.state} : #{self.name} "
    end
  
  def event_date_formatted
    date.present? ? date.to_formatted_s(:usa) : ""
  end
  
  def event_date_year
    date.present? ? date.year : "Dates TBD"
  end

  private

  def track_old_assigned_user
    self.old_assigned_user_id = assigned_user_id_was
  end

  def assigned_user_saved_change_and_not_self?
    saved_change_to_assigned_user_id? && assigned_user_id != Current.user&.id
  end

  def send_allocation_email
    return if assigned_user.nil?
  
    Rails.logger.info "📬 Sending assignment email for Event ##{id} to #{assigned_user.email}"
  
    EventMailer.assignment_email(assigned_user, self).deliver_later
  end

end