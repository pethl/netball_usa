class UsersController < ApplicationController
  def index
    authorize! :read, @users
    @users = User.where.not(confirmed_at: nil).where.not(role: 2).order(:role)
    @users_awaiting_confirmation = User.where(confirmed_at: nil)
    @users_awaiting_confirmation= @users_awaiting_confirmation.order(created_at: :asc)
    @team_leads = User.where.not(confirmed_at: nil).where(role: 2).order(:role)
  end
end
