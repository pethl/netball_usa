class Program < ApplicationRecord
  belongs_to :person, optional: true

  validates :program_stage, presence: true
  validates :program_name, presence: true
 
end
