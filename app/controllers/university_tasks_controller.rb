class UniversityTasksController < ApplicationController
  before_action :set_university_objective,
              only: [:new, :create],
              if: -> { params[:university_objective_id].present? }
  before_action :set_university_task,
                only: [:show, :edit, :update, :destroy]
  before_action :set_assignment_users,
              only: [:new, :create, :edit, :update]

  def index
    university_tasks = UniversityTask
      .joins(:university_objective)
      .includes(
        :university_objective,
        :assigned_user
      )
      .order(
        "university_objectives.title ASC",
        "university_tasks.status ASC",
        "university_tasks.position ASC"
      )

    @tasks_by_objective =
      university_tasks.group_by(&:university_objective)
  end

  def show
  end

  def new
  @university_task = UniversityTask.new(
    status: "Not Started",
    position: 0
  )

  if @university_objective.present?
    @university_task.university_objective = @university_objective
  end
end

def create
  @university_task = UniversityTask.new(university_task_params)
  @university_task.created_by = current_user
  @university_task.updated_by = current_user

  if @university_objective.present?
    @university_task.university_objective = @university_objective
  end

  if @university_task.save
    redirect_to university_objective_path(
      @university_task.university_objective
    ), notice: "University task was successfully created."
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit
  end

  def update
    @university_task.assign_attributes(
      university_task_params
    )

    @university_task.updated_by = current_user

    if @university_task.save
      redirect_to university_objective_path(
        @university_task.university_objective
      ), notice: "University task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    university_objective = @university_task.university_objective

    @university_task.destroy

    redirect_to university_objective_path(university_objective),
                notice: "University task was successfully deleted.",
                status: :see_other
  end

  private

  def set_university_objective
    @university_objective = UniversityObjective.find(
      params[:university_objective_id]
    )
  end

  def set_university_task
    @university_task = UniversityTask.find(params[:id])
  end

  def set_assignment_users
    group = UserGroup.find_by(
      key: "university_admin_team",
      active: true
    )

    team_users =
      if group.present?
        group.users
          .where(account_active: true)
          .to_a
      else
        []
      end

    existing_assignee = @university_task&.assigned_user

    @assignment_users = (
      team_users + [existing_assignee].compact
    ).uniq(&:id).sort_by do |user|
      user.full_name.downcase
    end
  end

  def university_task_params
    params.require(:university_task).permit(
      :university_objective_id,
      :assigned_user_id,
      :partner_id,
      :category,
      :action,
      :notes,
      :status,
      :due_date,
      :position
    )
  end
end