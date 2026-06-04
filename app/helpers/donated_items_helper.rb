module DonatedItemsHelper

  def donated_item_status_class(status)
  case status
  when "Available"
    "text-green-600 font-semibold"
  when "Requested"
    "text-yellow-500 font-semibold"
  when "Approved"
    "text-blue-800 font-semibold"
  when "Expired"
    "text-red-600 font-semibold"
  else
    "text-gray-800"
  end
end
end
