class Payment < ApplicationRecord
    belongs_to :NaTeam
    belongs_to :IndividualMember
end
