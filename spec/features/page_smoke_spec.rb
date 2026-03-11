# spec/features/page_smoke_spec.rb

require "rails_helper"

RSpec.feature "PageSmoke", type: :feature, js: true do
  scenario "admin user loads all important index pages successfully" do
    admin = create(:user, role: :admin, confirmed_at: Time.current)
    login_user(admin)

    pages = [
      { path: root_path, title: "Management Summary" },
      { path: netball_educators_path, title: "All Educators" },
      # { path: my_educators_netball_educators_path, title: "My Educators (allocated to me)" }, # SKIP AS ISSUE WITH PAGE TITLE
      { path: pe_directors_netball_educators_path, title: "P.E. Directors" },
      { path: equipment_index_path, title: "Equipment" },
      { path: follow_ups_path, title: "Educator Follow Up" },
      { path: educational_events_path, title: "Educational Events" },
      { path: search_netball_educators_path, title: "Educators: Search" },

      { path: sponsors_path, title: "Sponsors" },
      { path: opportunities_path, title: "Opportunities" },

      { path: grants_path, title: "Grants" },
      # { path: contacts_path, title: "Contacts" },
      { path: partners_path, title: "Partners" },

      { path: vendors_path, title: "Vendors" },

      { path: tours_path, title: "Tours" },

      { path: media_path, title: "Media" },
      { path: published_media_path, title: "Media: Published" },

      { path: people_path, title: "People" },

      { path: events_path, title: "Current Events" },

      { path: filings_path, title: "Filings" },

      { path: programs_path, title: "BAI Programs" },

      { path: venues_path, title: "Venues" },

      { path: open_invites_path, title: "US Open Invites" },
      { path: transfers_path, title: "US Open" },
      { path: inbound_pickups_transfers_path, title: "US Open - Arrivals Transfers" },
      { path: outbound_pickups_transfers_path, title: "US Open - Departures Transfers" },
      { path: netball_associations_index_path, title: "All Associations" },
      { path: index_admin_path, title: "Clubs" },
      { path: members_path, title: "Members" },
      # { path: clubs_path, title: "Clubs Managed by NA Administrators" }, # SKIP AS DATA RELATED ISSUES
      { path: individual_members_path, title: "Individual Members" },
      { path: teams_list_index_path, title: "Teams Year End Report" },
      { path: payments_path, title: "Payments" },
      { path: kidos_netball_educators_path, title: "Kidos" },
      { path: talentlockr_netball_educators_path, title: "TalentLockr" },
      { path: trainers_etc_netball_educators_path, title: "Trainers & Ambassadors" },
      { path: heat_map_netball_educators_path, title: "Educators - Heat Map" },

      # ADMIN PATHS
      { path: budgets_path, title: "Budgets" },
      { path: references_path, title: "Reference Data" },
      { path: sample_words_path, title: "Sample Words" },
      { path: users_path, title: "Users" }
    ]

    visited_count = 0

    aggregate_failures("All critical pages load correctly") do
      pages.each do |page_info|
        visit page_info[:path]

        if page.title.nil?
          puts "\e[31m❌ Failed to load page #{page_info[:path]} (No title found)\e[0m"
          raise "Failed to load page: #{page_info[:path]}"
        else
          expect(page).to have_title(/#{page_info[:title]}/i),
            "Expected page title to include '#{page_info[:title]}' for #{page_info[:path]}"

          visited_count += 1

          puts "\e[32m✅ Successfully loaded #{page_info[:title]} page (#{page_info[:path]})\e[0m"
        end
      end
    end

    puts "\n\e[34m🚀 Smoke test completed: #{visited_count}/#{pages.count} pages visited successfully\e[0m"

# -----------------------------
# Detect missing routes
# -----------------------------

tested_paths = pages.map { |p| p[:path].to_s }

rails_index_routes = Rails.application.routes.routes
  .map { |r| r.path.spec.to_s }
  .select { |p| p.end_with?("(.:format)") }
  .map { |p| p.gsub("(.:format)", "") }
  .select { |p| p.split("/").length <= 3 } # keeps only index-ish routes

missing = rails_index_routes.reject do |route|
  tested_paths.any? { |tested| route.include?(tested) }
end

if missing.any?
  puts "\n\e[33m⚠️ Smoke test missing possible index routes:\e[0m"
  missing.each { |m| puts "  - #{m}" }
end
  end
end