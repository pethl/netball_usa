class UsersController < ApplicationController
  load_and_authorize_resource only: :index

  before_action :require_admin,
                only: [:groups, :update_groups, :profile, :update_profile, :access_report]

  before_action :set_user,
                only: [:groups, :update_groups, :profile, :update_profile]

  def index
    authorize! :index, User

    users = User
      .accessible_by(current_ability)
      .includes(:person)
      .order(
        account_active: :desc,
        last_name: :asc,
        first_name: :asc
      )

    @admin_users = users.where(role: :admin)

    @office_users = users.where.not(
      role: [
        User.roles.fetch("admin"),
        User.roles.fetch("na_people"),
        User.roles.fetch("teamlead")
      ]
    )

    @na_people = users.where(role: :na_people)
    @team_leads = users.where(role: :teamlead)
  end

  def access_report
    @access_report = OfficeAccessReport.new

    respond_to do |format|
      format.html
      format.pdf do
        send_data OfficeAccessReportPdfService.new(@access_report).generate,
                  filename: "office_user_access_#{Date.current.iso8601}.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
      end
    end
  end

  def groups
    @user_groups = UserGroup.active.ordered
    @selected_group_ids = @user.user_group_ids
  end

  def update_groups
    selected_group_ids = UserGroup
      .active
      .where(id: submitted_group_ids)
      .pluck(:id)

    UserGroupMembership.transaction do
      active_memberships = @user
        .user_group_memberships
        .joins(:user_group)
        .where(user_groups: { active: true })

      active_memberships
        .where.not(user_group_id: selected_group_ids)
        .destroy_all

      selected_group_ids.each do |user_group_id|
        @user.user_group_memberships.find_or_create_by!(
          user_group_id: user_group_id
        )
      end
    end

    redirect_to groups_user_path(@user),
                notice: "User groups were updated."
  rescue ActiveRecord::RecordInvalid => error
    @user_groups = UserGroup.active.ordered
    @selected_group_ids = submitted_group_ids.map(&:to_i)

    flash.now[:alert] =
      error.record.errors.full_messages.to_sentence

    render :groups, status: :unprocessable_entity
  end

  def profile
    set_available_people
  end

  def update_profile
    person_id = params.dig(:user, :person_id).presence

    Person.transaction do
      if person_id.present?
        person = Person
          .where(user_id: [nil, @user.id])
          .find(person_id)

        current_person = @user.person

        if current_person.present? && current_person.id != person.id
          current_person.update!(user: nil)
        end

        person.update!(user: @user)
      elsif @user.person.present?
        @user.person.update!(user: nil)
      end
    end

    redirect_to users_path,
                notice: "Linked Person profile was updated.",
                status: :see_other
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => error
    set_available_people
    flash.now[:alert] = error.message
    render :profile, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def submitted_group_ids
    Array(params.dig(:user, :user_group_ids))
      .reject(&:blank?)
  end

  def set_available_people
    @available_people = Person
      .where(user_id: [nil, @user.id])
      .order(:first_name, :last_name)
  end

  def require_admin
    raise CanCan::AccessDenied unless current_user&.admin?
  end
end
