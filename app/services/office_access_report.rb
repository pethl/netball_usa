# frozen_string_literal: true

class OfficeAccessReport
  Access = Struct.new(:model_name, :access_level, :users, keyword_init: true)
  UserAccess = Struct.new(:user, :groups, :access, keyword_init: true)

  UNIVERSAL_ACCESS = [
    ["User account", "View and update their own account"],
    ["Person", "View and update their own linked profile"],
    ["Transfer", "View and update their own existing transfer for the current US Open"]
  ].freeze

  ACCESS_CHECKS = [
    ["Clubs", "Full administration", ->(ability) { ability.can?(:manage, Club) }],
    ["Clubs", "View membership administration lists", ->(ability) { ability.can?(:index_admin, Club) && ability.cannot?(:manage, Club) }],
    ["Clubs", "View clubs index", ->(ability) { ability.can?(:index_user, Club) }],
    ["Contacts", "Full administration", ->(ability) { ability.can?(:manage, Contact) }],
    ["Donated item requests", "Create requests", ->(ability) { ability.can?(:create, DonatedItemRequest) }],
    ["Donated items", "View", ->(ability) { ability.can?(:read, DonatedItem) }],
    ["Educator equipment", "Full administration", ->(ability) { ability.can?(:manage, Equipment) }],
    ["Educator follow-ups", "Full administration", ->(ability) { ability.can?(:manage, FollowUp) }],
    ["Educators", "Full administration", ->(ability) { ability.can?(:manage, NetballEducator) }],
    ["Educators", "Export personal details", ->(ability) { ability.can?(:export, NetballEducator) }],
    ["Events", "Manage except delete", ->(ability) { ability.can?(:update, Event) && ability.cannot?(:destroy, Event) }],
    ["Events", "View all records", ->(ability) { ability.can?(:read, Event) && ability.cannot?(:update, Event) }],
    ["Events calendar", "View", ->(ability) { ability.can?(:calendar, Event) }],
    ["Grants", "Full administration", ->(ability) { ability.can?(:manage, Grant) }],
    ["Individual members", "Full administration", ->(ability) { ability.can?(:manage, IndividualMember) }],
    ["Individual members", "View", ->(ability) { ability.can?(:read_all, IndividualMember) && ability.cannot?(:manage, IndividualMember) }],
    ["Media", "Full administration", ->(ability) { ability.can?(:manage, Medium) }],
    ["Members", "Full administration", ->(ability) { ability.can?(:manage, Member) }],
    ["Members", "View", ->(ability) { ability.can?(:read, Member) && ability.cannot?(:manage, Member) }],
    ["Netball academies", "Full administration", ->(ability) { ability.can?(:manage, NetballAcademy) }],
    ["Opportunities", "Manage own records", ->(ability) { ability.can?(:manage, Opportunity) }],
    ["Partners", "Full administration", ->(ability) { ability.can?(:manage, Partner) }],
    ["Partners", "View university partners", ->(ability) { ability.can?(:university, Partner) && ability.cannot?(:manage, Partner) }],
    ["Payments", "Full administration", ->(ability) { ability.can?(:manage, Payment) }],
    ["People", "Full administration", ->(ability) { ability.can?(:manage, Person) }],
    ["People", "View university squad", ->(ability) { ability.can?(:university_squad, Person) && ability.cannot?(:manage, Person) }],
    ["Programs", "Full administration", ->(ability) { ability.can?(:manage, Program) }],
    ["Sponsors", "Full administration", ->(ability) { ability.can?(:manage, Sponsor) }],
    ["Transfers", "Full administration", ->(ability) { ability.can?(:manage, Transfer) }],
    ["Tours", "Full administration", ->(ability) { ability.can?(:manage, Tour) }],
    ["University objectives", "View", ->(ability) { ability.can?(:read, UniversityObjective) }],
    ["University tasks", "View and update assigned tasks", ->(ability) { ability.can?(:my_tasks, UniversityTask) }],
    ["Vendors", "Full administration", ->(ability) { ability.can?(:manage, Vendor) }],
    ["Venues", "Full administration", ->(ability) { ability.can?(:manage, Venue) }]
  ].freeze

  attr_reader :users, :by_model, :by_user

  def initialize(users: default_users)
    @users = users.to_a.sort_by { |user| [user.last_name.to_s.downcase, user.first_name.to_s.downcase] }
    abilities = @users.index_with { |user| Ability.new(user) }

    @by_model = ACCESS_CHECKS.filter_map do |model_name, access_level, permitted|
      permitted_users = @users.select { |user| permitted.call(abilities.fetch(user)) }
      next if permitted_users.empty?

      Access.new(
        model_name: model_name,
        access_level: access_level,
        users: permitted_users
      )
    end

    @by_user = @users.map do |user|
      UserAccess.new(
        user: user,
        groups: user.user_groups.select(&:active?).sort_by { |group| group.name.downcase },
        access: @by_model.select { |entry| entry.users.include?(user) }
      )
    end
  end

  private

  def default_users
    User
      .where(role: :office)
      .includes(:person, :user_groups)
  end
end
