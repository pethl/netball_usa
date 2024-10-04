class Event < ApplicationRecord
  has_many :event_participants, dependent: :destroy
  has_many :people, through: :event_participants
  has_many :event_assignments, dependent: :destroy
  has_many :transfers, through: :event_assignments
  belongs_to :budget, optional: true 
   
  validates :event_type, presence: true
  validates :name, presence: true

  scope :ordered, -> { order(date: :asc) }


  def budget
    Budget.where(event_id: self.id).first
  end
  
  def budget_count
      a = Budget.where(event_id: self.id)
      if a.empty?()
        return 0
      else
        return a
      end
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
    self.date.year
  end
end