require "rails_helper"

RSpec.describe "User group access", type: :request do
  include Devise::Test::IntegrationHelpers

  def create_group(key, name: key.humanize, active: true)
    UserGroup.create!(key: key, name: name, active: active)
  end

  def add_to_group(user, key)
    group = UserGroup.find_by(key: key) || create_group(key)
    UserGroupMembership.create!(user: user, user_group: group)
    group
  end

  describe "persisted membership permissions" do
    let(:user) { create(:user, role: :office) }

    it "uses a saved active membership when building the Ability" do
      add_to_group(user, "partners_team")

      ability = Ability.new(user.reload)

      expect(user).to be_in_group("partners_team")
      expect(ability.can?(:manage, Partner)).to be(true)
      expect(ability.can?(:manage, Person)).to be(false)
    end

    it "ignores a saved membership when its group is inactive" do
      inactive_group = create_group(
        "partners_team",
        active: false
      )
      UserGroupMembership.create!(user: user, user_group: inactive_group)

      ability = Ability.new(user.reload)

      expect(user).not_to be_in_group("partners_team")
      expect(ability.can?(:manage, Partner)).to be(false)
    end

    it "keeps US Open Transfers separate from People administration" do
      add_to_group(user, "us_open_team")

      transfer_only_ability = Ability.new(user.reload)

      expect(transfer_only_ability.can?(:manage, Transfer)).to be(true)
      expect(transfer_only_ability.can?(:manage, Person)).to be(false)

      add_to_group(user, "people_team")
      combined_ability = Ability.new(user.reload)

      expect(combined_ability.can?(:manage, Transfer)).to be(true)
      expect(combined_ability.can?(:manage, Person)).to be(true)
    end
  end

  describe "educator export" do
    let(:user) { create(:user, role: :office) }

    before do
      add_to_group(user, "educators_events_team")
      sign_in user
    end

    it "hides and blocks export for educator managers without the export group" do
      get netball_educators_path
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("To Excel &gt;")

      get netball_educators_path(format: :xlsx)
      expect(response).to redirect_to(netball_educators_path(locale: :en))
    end

    it "shows and permits export after the explicit export group is added" do
      add_to_group(user, "educators_export_team")

      get netball_educators_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("To Excel &gt;")

      get netball_educators_path(format: :xlsx)
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq(
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      )
    end
  end

  describe "membership viewing" do
    let(:user) { create(:user, role: :office) }
    let!(:first_member) do
      create(
        :individual_member,
        first_name: "Alpha",
        last_name: "Member",
        email: "alpha.member@example.com"
      )
    end
    let!(:second_member) do
      create(
        :individual_member,
        first_name: "Beta",
        last_name: "Member",
        email: "beta.member@example.com"
      )
    end

    before do
      add_to_group(user, "membership_view_team")
      sign_in user
    end

    it "lists all Individual Members but does not permit editing them" do
      get individual_members_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(first_member.email)
      expect(response.body).to include(second_member.email)

      get edit_individual_member_path(first_member)
      expect(response).to redirect_to(root_url(locale: :en))
    end
  end

  describe "permission-driven navigation" do
    let(:user) { create(:user, role: :office) }

    before do
      create(
        :event,
        event_type: "US Open",
        name: "Current US Open navigation spec",
        date: Date.current.end_of_year
      )
      sign_in user
    end

    it "places Educators before US Open for a user in both groups" do
      add_to_group(user, "educators_events_team")
      add_to_group(user, "us_open_team")

      get root_path

      menu_text = main_menu.text
      expect(menu_text.index("EDUCATORS")).to be < menu_text.index("US OPEN")
    end

    it "does not repeat the restricted Membership menu for an administrator" do
      add_to_group(user, "membership_admin_team")

      get root_path

      expect(main_menu.text.scan("MEMBERSHIP").size).to eq(1)
      expect(main_menu.text).to include("All Clubs")
      expect(main_menu.text).not_to include("\n- Clubs\n")
    end

    it "renders only the narrow links for calendar and Clubs-index groups" do
      add_to_group(user, "events_calendar_team")
      add_to_group(user, "clubs_index_view_team")

      get root_path

      menu = main_menu
      expect(menu.css("a[href*='/events/calendar']").size).to eq(1)
      expect(menu.css("a[href*='/events']").map(&:text).join).not_to include(
        "Event Attendees"
      )
      expect(menu.css("a[href*='/clubs/index_user']").size).to eq(1)
      expect(menu.text).not_to include("All Clubs")
      expect(menu.text).not_to include("All Members")
    end
  end

  describe "User Groups index" do
    let(:admin) { create(:user, :admin) }

    it "orders by key and renders every group closed with its member count" do
      later_group = create_group("zebra_team", name: "First by name")
      earlier_group = create_group("alpha_team", name: "Last by name")
      member = create(:user, role: :office)
      UserGroupMembership.create!(user: member, user_group: earlier_group)
      sign_in admin

      get user_groups_path

      expect(response).to have_http_status(:ok)
      document = Nokogiri::HTML(response.body)
      sections = document.css("section[data-controller='accordion']")
      keys = sections.map do |section|
        section.at_css("p.font-mono").text.strip
      end

      expect(keys).to eq(keys.sort)
      expect(keys).to include("alpha_team", "zebra_team")

      alpha_section = sections.find do |section|
        section.at_css("p.font-mono").text.strip == "alpha_team"
      end
      zebra_section = sections.find do |section|
        section.at_css("p.font-mono").text.strip == "zebra_team"
      end

      expect(alpha_section.text).to include("1 member")
      expect(zebra_section.text).to include("0 members")
      expect(
        sections.all? do |section|
          section.at_css("[data-accordion-target='body']")["class"].split.include?("hidden")
        end
      ).to be(true)
      expect(later_group).to be_present
    end
  end

  describe "office access report" do
    let(:admin) { create(:user, :admin) }

    it "allows an administrator to view and download the role 4 report" do
      office_user = create(
        :user,
        role: :office,
        first_name: "Report",
        last_name: "Tester"
      )
      create_group("grants_team", name: "Grants Team")
      add_to_group(office_user, "grants_team")
      sign_in admin

      get access_report_users_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Selected access by model")
      expect(response.body).to include("Report Tester")
      expect(response.body).to include("Grants Team")

      get access_report_users_path(format: :pdf)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to include(
        "office_user_access_#{Date.current.iso8601}.pdf"
      )
    end

    it "blocks a non-administrator" do
      office_user = create(:user, role: :office)
      sign_in office_user

      get access_report_users_path

      expect(response).to redirect_to(root_url(locale: :en))
    end
  end

  describe "shared User Admin navigation" do
    let(:admin) { create(:user, :admin) }

    before do
      sign_in admin
    end

    it "shows all three tabs and highlights the current page" do
      {
        users_path => "Users",
        user_groups_path => "Groups",
        access_report_users_path => "Access Report"
      }.each do |path, active_label|
        get path

        expect(response).to have_http_status(:ok)
        nav = user_admin_nav
        expect(nav).to be_present
        expect(nav.css("a").map { |link| link.text.strip }).to eq(
          ["Users", "Groups", "Access Report"]
        )

        active_links = nav.css("a").select do |link|
          link["class"].to_s.split.include?("border-blue-900")
        end
        expect(active_links.map { |link| link.text.strip }).to eq([active_label])
      end
    end

    it "shows only the action belonging to each main page" do
      get users_path
      expect(response.body).to include("Create user account")
      expect(response.body).not_to include("Download PDF")

      get user_groups_path
      expect(response.body).not_to include("Create user account")
      expect(response.body).not_to include("Download PDF")

      get access_report_users_path
      expect(response.body).to include("Download PDF")
      expect(response.body).not_to include("Create user account")
    end
  end

  describe "User Admin authorization" do
    it "blocks an office user from all three main pages" do
      sign_in create(:user, role: :office)

      [users_path, user_groups_path, access_report_users_path].each do |path|
        get path
        expect(response).to redirect_to(root_url(locale: :en))
      end
    end
  end

  def main_menu
    document = Nokogiri::HTML(response.body)
    document.css("ul").find do |list|
      list["class"].to_s.split.include?("ml-6")
    end
  end

  def user_admin_nav
    Nokogiri::HTML(response.body).at_css(
      "nav[aria-label='User administration']"
    )
  end
end
