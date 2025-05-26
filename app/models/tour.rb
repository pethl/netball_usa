class Tour < ApplicationRecord
    validates :company, presence: true

    scope :ordered_by_company, -> { order("LOWER(company) ASC") }

    #SEE DUPLICATED CODE TO PARTNER
    def contact_two_blank
        if (first_name_secondary.to_s +
            last_name_secondary.to_s +
            role_secondary.to_s +
            email_secondary.to_s +
            cell_secondary.to_s +
            work_phone_secondary.to_s).empty?
            false
        else
            true
        end
    end

    def contact_three_blank
        if (first_name_third.to_s +
            last_name_third.to_s +
            role_third.to_s +
            email_third.to_s +
            cell_third.to_s +
            work_phone_third.to_s).empty?
            false
        else
            true
        end
    end

#DUP TO SPONSOR PARTNET
    def address_condensed
        parts = [location, city, us_state, country].reject(&:blank?)
        parts.join(", ")
    end

end
