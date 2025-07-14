module NetballEducatorsHelper

def kidokinetics?(educator)
  educator.role == "Kidokinetics"
end

def page_title_for(educator)
  name = "#{educator.first_name} #{educator.last_name}"

  if educator.role == "Kidokinetics"
    "Kidos: #{name}"
  elsif educator.is_pe_director?
    "P.E. Director: #{name}"
  else
    "Educator: #{name}"
  end
end

end