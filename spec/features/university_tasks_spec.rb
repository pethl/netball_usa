require "rails_helper"

RSpec.describe "University task list", type: :feature do
  let(:admin_user) do
    create(:user, :admin, password: "password123")
  end

  before do
    Reference.create!(
      group: "university_objective_timeframe",
      value: "Short Term",
      active: true
    )

    Reference.create!(
      group: "university_task_category",
      value: "Recruitment",
      active: true
    )

    Reference.create!(
      group: "university_task_status",
      value: "Not Started",
      active: true
    )

    Reference.create!(
      group: "university_task_status",
      value: "Complete",
      active: true
    )

    login_user(admin_user)
  end

  scenario "Admin views tasks grouped by objective" do
    later_objective = UniversityObjective.create!(
      title: "Build the squad",
      description: "Recruit and prepare the playing squad",
      timeframe: "Short Term",
      position: 2
    )

    first_objective = UniversityObjective.create!(
      title: "Arrange university partnerships",
      description: "Develop university relationships",
      timeframe: "Short Term",
      position: 1
    )

    assigned_user = create(
      :user,
      first_name: "Alex",
      last_name: "Morgan"
    )

    UniversityTask.create!(
      university_objective: first_objective,
      category: "Recruitment",
      action: "Contact university athletics departments",
      status: "Not Started",
      assigned_user: assigned_user,
      due_date: Date.new(2026, 10, 15),
      position: 1
    )

    UniversityTask.create!(
      university_objective: later_objective,
      category: "Recruitment",
      action: "Confirm eligible players",
      status: "Complete",
      position: 1
    )

    visit university_tasks_path

    expect(page).to have_link("Add Task")

    expect(page).to have_link(
      "Arrange university partnerships"
    )
    expect(page).to have_link("Build the squad")

    expect(page).to have_link(
      "Contact university athletics departments"
    )
    expect(page).to have_content("Not Started")
    expect(page).to have_content("Alex Morgan")
    expect(page).to have_content("Oct 15, 26")

    expect(page).to have_link("Confirm eligible players")
    expect(page).to have_content("Complete")
    expect(page).to have_content("Not assigned")

    expect(
      page.body.index("Arrange university partnerships")
    ).to be < page.body.index("Build the squad")
  end

  scenario "Admin sees an empty message when no tasks exist" do
    visit university_tasks_path

    expect(page).to have_content(
      "No university programme objective tasks to view"
    )
  end
end
