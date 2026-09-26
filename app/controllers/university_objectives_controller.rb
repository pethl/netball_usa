class UniversityObjectivesController < ApplicationController
  before_action :set_university_objective,
              only: [:show, :edit, :update, :destroy]
                load_and_authorize_resource

  def index
    @short_term_objectives = UniversityObjective
      .short_term
      .ordered

    @long_term_objectives = UniversityObjective
      .long_term
      .ordered
  end

  def new
    @university_objective = UniversityObjective.new(
      active: true,
      position: 0
    )
  end

  def create
    @university_objective = UniversityObjective.new(
      university_objective_params
    )

    if @university_objective.save
      redirect_to university_objectives_path,
                  notice: "University objective was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @university_objective.update(university_objective_params)
      redirect_to university_objectives_path,
                  notice: "University objective was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @university_tasks = @university_objective
      .university_tasks
      .ordered
  end


  private

  def university_objective_params
    params.require(:university_objective).permit(
      :timeframe,
      :title,
      :description,
      :position,
      :active
    )
  end

  def set_university_objective
    @university_objective = UniversityObjective.find(params[:id])
  end
end