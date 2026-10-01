require "rails_helper"

RSpec.describe "Dashboard", type: :feature do
  let(:admin_user) do
    create(:user, :admin, password: "password123")
  end

  before do
    ensure_active_reference(
      group: "university_objective_timeframe",
      value: "Short Term"
    )

    ensure_active_reference(
      group: "university_task_category",
      value: "Recruitment"
    )

    ensure_active_reference(
      group: "university_task_status",
      value: "Not Started"
    )

    ensure_active_reference(
      group: "university_task_status",
      value: "Complete"
    )

    objective = UniversityObjective.create!(
      title: "Test the university programme",
      timeframe: "Short Term",
      position: 0
    )

    UniversityTask.create!(
      university_objective: objective,
      category: "Recruitment",
      action: "Contact prospective players",
      status: "Not Started",
      position: 0
    )

    UniversityTask.create!(
      university_objective: objective,
      category: "Recruitment",
      action: "Confirm the first squad",
      status: "Complete",
      position: 1
    )

    create(:partner, usa_university_partner: true)
    create(:partner, usa_university_partner: false)

    create_university_player(
      "confirmed",
      "Yes - Eligible"
    )

    create_university_player(
      "future",
      "2028"
    )

    create_university_player(
      "unknown",
      nil
    )

    create_university_player(
      "withdrawn",
      "Withdrawn"
    )

    login_user(admin_user)
  end

  scenario "Admin sees the correct university programme totals" do
    expected_complete =
      UniversityTask
        .where("status ILIKE ?", "Complete%")
        .count

    expected_open =
      UniversityTask
        .where("status NOT ILIKE ?", "Complete%")
        .count

    expected_partners =
      Partner
        .where(usa_university_partner: true)
        .count

    university_players =
      Person
        .where(role: "University Squad")
        .left_joins(:university_athlete_profile)

    expected_confirmed =
      university_players
        .where(
          "university_athlete_profiles.final_eligibility ILIKE ?",
          "Yes%"
        )
        .count

    expected_future =
      university_players
        .where(
          <<~SQL.squish,
            university_athlete_profiles.final_eligibility IS NULL
            OR (
              university_athlete_profiles.final_eligibility
                NOT ILIKE :confirmed
              AND university_athlete_profiles.final_eligibility
                NOT ILIKE :withdrawn
            )
          SQL
          confirmed: "Yes%",
          withdrawn: "Withdrawn%"
        )
        .count

    visit root_path

    university_card = find(
      "a[href*='/university_objectives']",
      text: "USA UNI"
    )

    within(university_card) do
      expect(page).to have_content("USA UNI")
      expect(page).to have_content(
        "Open #{expected_open}"
      )
      expect(page).to have_content(
        "Complete #{expected_complete}"
      )
      expect(page).to have_content(
        "Partners #{expected_partners}"
      )
      expect(page).to have_content(
        "Squad — Confirmed #{expected_confirmed}"
      )
      expect(page).to have_content(
        "Future Players #{expected_future}"
      )
      expect(page).to have_content("Budget")
    end
  end

  def ensure_active_reference(group:, value:)
    reference = Reference.find_or_initialize_by(
      group: group,
      value: value
    )

    reference.active = true
    reference.save!
  end

  def create_university_player(identifier, eligibility)
    person = create(
      :person,
      first_name: identifier.capitalize,
      last_name: "Player",
      email: "#{identifier}.player@example.com",
      role: "University Squad"
    )

    UniversityAthleteProfile.create!(
      person: person,
      final_eligibility: eligibility
    )
  end
end