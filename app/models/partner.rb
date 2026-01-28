class Partner < ApplicationRecord
    has_many :contacts
   # has_one :person - not sure what this was doe
    belongs_to :user

    validates :company, presence: { message: ": Please enter name before attempting to save" }
    scope :ordered, -> { order(company: :asc) }

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

    def address_condensed
        parts = []
      
        # street / location
        parts << location if location.present?
      
        # city + state + zip on one line
        city_state_zip = [city, us_state, zip_code].compact.reject(&:blank?).join(" ")
        parts << city_state_zip if city_state_zip.present?
      
        # country
        parts << country if country.present?
      
        parts.join(", ")
      end

      def address_index_compact
        line_one = [city, us_state, zip_code]
                     .compact
                     .reject(&:blank?)
                     .join(" ")
      
        line_two = country.presence
      
        [line_one, line_two].compact.join("<br>").html_safe
      end
end
