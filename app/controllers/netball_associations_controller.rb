class NetballAssociationsController < ApplicationController
  before_action :set_netball_association, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  def index
    @netball_associations = NetballAssociation.ordered
  end

  def show
    @clubs = @netball_association.clubs.includes(:creator) # eager load to avoid N+1
  end

  def new
    @netball_association = NetballAssociation.new
  end

  def create
    @netball_association = NetballAssociation.new(netball_association_params)
    @netball_association.user = current_user # assumes user is logged in

    if @netball_association.save
      redirect_to @netball_association, notice: 'Netball Association was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @netball_association.update(netball_association_params)
      redirect_to @netball_association, notice: 'Netball Association was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @netball_association.destroy
    redirect_to netball_associations_path, notice: 'Netball Association was deleted.'
  end

  private

  def set_netball_association
    @netball_association = NetballAssociation.find(params[:id])
  end

  def netball_association_params
    params.require(:netball_association).permit(
      :name, :city, :state, :country,
      :email, :website, :facebook, :twitter, :instagram, :number_of_clubs, :notes
    )
  end

  def require_admin
    unless current_user&.role == 2
      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
