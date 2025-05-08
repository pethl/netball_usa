class Event < ApplicationRecord
  has_many :event_participants, dependent: :destroy
  has_many :people, through: :event_participants
  has_many :netball_educators, through: :event_participants
  has_many :event_assignments, dependent: :destroy
 # has_many :transfers, through: :event_assignments
  has_many :transfers

  has_one :budget #, dependent: :destroy
   
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
  
  def event_date_formatted
    self.date.to_formatted_s(:usa) 
  end
  
  def event_date_year
    date.present? ? date.year : "Dates TBD"
  end
end