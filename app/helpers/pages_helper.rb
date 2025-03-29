# app/helpers/pages_helper.rb
module PagesHelper
    ROLE_HOME_VIEWS = {
      "admin" => { partial: "admin_home", title: "Management Summary" },
      "us_open" => { partial: "us_open_home", title: "Dashboard" },
      "teams_grants" => { partial: "office_home", title: "Dashboard" },
      "grants" => { partial: "office_home", title: "Dashboard" },
      "educators" => { partial: "office_home", title: "Dashboard" },
      "sponsors_events" => { partial: "office_home", title: "Dashboard" },
      "educators_events" => { partial: "office_home", title: "Dashboard" },
      "teams_admin" => { partial: "office_home", title: "Dashboard" },
      "sponsors_media" => { partial: "office_home", title: "Dashboard" },
      "educators_events_medium" => { partial: "office_home", title: "Dashboard" },
      "na_people" => { partial: "na_people", title: "Dashboard" },
    }.freeze
  
    def role_config
      ROLE_HOME_VIEWS[current_user.role]
    end
  end
  