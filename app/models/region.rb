class Region < ApplicationRecord
   scope :ordered, -> { order(region: :desc) }
   
   def get_teams
     @list_of_states= Region.where(region: self.region)
     @list_of_states.pluck(:state)
     @teams = Team.where('state IN (?)', @list_of_states)
 end
 
  def get_states
    @list_of_states= Region.where(region: self.region)
    @list_of_states.pluck(:state)
   # @teams = Team.where('state IN (?)', @list_of_states)
end
end
