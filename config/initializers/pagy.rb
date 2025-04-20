require "pagy"
require Rails.root.join('lib/pagy/extras/tailwind.rb')

module Pagy::Frontend
  def pagy_link_proc(pagy)
    lambda do |page_number|
      query_params = request.query_parameters.merge(pagy.vars[:page_param] => page_number)
      href = "#{request.path}?#{query_params.to_query}"
      href
    end
  end
end
