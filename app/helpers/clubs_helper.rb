module ClubsHelper

  def club_renewal_status(club)
    if club.new_this_year?
      content_tag(:span, "New Club", class: "text-blue-700 font-semibold")
    elsif club.renewed_for_year?(current_membership_year)
      content_tag(:span, "Renewed for #{current_membership_year}", class: "text-green-700 font-semibold")
    else
      content_tag(:span, "Not Yet Renewed", class: "text-red-600 font-semibold")
    end
  end

end
