# frozen_string_literal: true

class Pagy
  module TailwindExtra
    def pagy_tailwind_nav(pagy)
      link_proc = pagy_link_proc(pagy)
      html = +%(<nav class="pagy-nav" role="navigation" aria-label="Pagination"><ul class="inline-flex items-center -space-x-px text-sm">)

      pagy.series.each do |item|
        case item
        when Integer
          html << %(<li><a href="#{link_proc.call(item)}" class="z-10 bg-white border border-gray-300 text-gray-900 hover:bg-gray-100 hover:text-blue-700 px-3 py-2 leading-tight">#{item}</a></li>)
        when String
          html << %(<li><span class="z-10 bg-blue-50 border border-blue-300 text-blue-600 px-3 py-2 leading-tight">#{item}</span></li>)
        when :gap
          html << %(<li><span class="z-10 bg-white border border-gray-300 text-gray-500 px-3 py-2 leading-tight">…</span></li>)
        end
      end

      html << %(</ul></nav>)
    end
  end

  Frontend.prepend TailwindExtra
end

