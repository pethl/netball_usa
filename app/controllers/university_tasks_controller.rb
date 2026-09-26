class UniversityTasksController < ApplicationController
  before_action :set_university_objective,
              only: [:new, :create],
              if: -> { params[:university_objective_id].present? }
  before_action :set_university_task,
                only: [:show, :edit, :update, :destroy]

  def index
    @university_tasks = UniversityTask
      .joins(:university_objective)
      .includes(:university_objective)
      .order(
        "university_objectives.title ASC",
        "university_tasks.status ASC",
        "university_tasks.position ASC"
      )
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
    if @university_task.update(university_task_params)
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

  def university_task_params
    params.require(:university_task).permit(
      :university_objective_id,
      :category,
      :action,
      :notes,
      :status,
      :due_date,
      :position
    )
  end
end