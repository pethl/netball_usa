require "rails_helper"

RSpec.describe OfficeAccessReport do
  def add_to_group(user, key, name: key.humanize)
    group = UserGroup.create!(key: key, name: name, active: true)
    UserGroupMembership.create!(user: user, user_group: group)
  end

  it "reports current Ability access for office users only" do
    office_user = create(
      :user,
      role: :office,
      first_name: "Alex",
      last_name: "Office"
    )
    add_to_group(office_user, "grants_team")
    add_to_group(office_user, "events_calendar_team")
    create(:user, :admin, first_name: "Ada", last_name: "Admin")

    report = described_class.new(users: User.where(id: office_user.id))
    grants = report.by_model.find { |entry| entry.model_name == "Grants" }
    calendar = report.by_model.find { |entry| entry.model_name == "Events calendar" }

    expect(report.users).to eq([office_user])
    expect(grants.users).to eq([office_user])
    expect(calendar.users).to eq([office_user])
    expect(report.by_model.map(&:model_name)).not_to include("Audit", "Ref Data")
  end

  it "keeps universal own-record access separate from selected access" do
    office_user = create(:user, role: :office)

    report = described_class.new(users: User.where(id: office_user.id))
    user_entry = report.by_user.find { |entry| entry.user == office_user }

    expect(described_class::UNIVERSAL_ACCESS).to include(
      ["Person", "View and update their own linked profile"]
    )
    expect(user_entry.access).to be_empty
  end
end
