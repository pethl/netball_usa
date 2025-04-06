# spec/features/page_smoke_spec.rb

require 'rails_helper'

RSpec.feature "PageSmoke", type: :feature, js: true do
  scenario "admin user loads all important index pages successfully" do
    admin = create(:user, role: :admin, confirmed_at: Time.current)
    login_user(admin)

    # Pages to check
    pages = [
      { path: root_path, title: "Management Summary" },
      { path: netball_educators_path, title: "All Educators" },
      { path: pe_directors_netball_educators_path, title: "P.E. Directors" },
       #{ path: equipment_path, title: "Equipment" },
       { path: educational_events_path, title: "Educational Events" },

      { path: follow_ups_path, title: "Educator Follow Up" },
     
      { path: sponsors_path, title: "Sponsors" },
      { path: opportunities_path, title: "Opportunities" },

      { path: grants_path, title: "Grants" },
      #{ path: contacts_path, title: "Contacts" },
      { path: partners_path, title: "Partners" },

      { path: vendors_path, title: "Vendors" },

      { path: tours_path, title: "Tours" },

      { path: media_path, title: "Media" },
      { path: published_media_path, title: "Media: Published" },

      { path: people_path, title: "People" },

      { path: events_path, title: "All Events" },

      { path: programs_path, title: "BAI Programs" },

      { path: venues_path, title: "Venues" },

      { path: open_invites_path, title: "US Open Invites" },
      { path: transfers_path, title: "US Open" },
      # missing pages here

      { path: members_path, title: "Members" },
      { path: individual_members_path, title: "Individual Members" },
      { path: "/clubs/teams_list_index", title: "Teams Year End Report" },
      { path: payments_path, title: "Payments" },

     # ADMIN PATHS
      { path: "/clubs/index_admin", title: "Clubs" },
      { path: budgets_path, title: "Budgets" },
      { path: references_path, title: "Reference Data" },
      { path: sample_words_path, title: "Sample Words" },
      { path: users_path, title: "Users" }
     
    ]

    aggregate_failures("All critical pages load correctly") do
      pages.each do |page_info|
        visit page_info[:path]
      
        if page.title.nil?
          puts "\e[31m❌ Failed to load page #{page_info[:path]} (No title found)\e[0m"
          raise "Failed to load page: #{page_info[:path]}"
        else
          expect(page).to have_title(/#{page_info[:title]}/i), "Expected page title to include '#{page_info[:title]}' for #{page_info[:path]}"
          puts "\e[32m✅ Successfully loaded #{page_info[:title]} page (#{page_info[:path]})\e[0m"
        end
      end
      
    end
  end
end

