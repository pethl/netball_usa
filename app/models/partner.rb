class Partner < ApplicationRecord
    has_many :contacts

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
end
