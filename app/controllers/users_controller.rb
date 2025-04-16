class UsersController < ApplicationController
  load_and_authorize_resource
  def index
    authorize! :index, User
    # 🔹 Confirmed + Active System Users (excluding role 2 = team lead)
    @users = User
      .accessible_by(current_ability)
      .where.not(confirmed_at: nil)
      .where.not(role: 2)
      .where(account_active: true)
      .order(:role, :last_name)
  
    # 🔹 Team Leads (confirmed, role == 2)
    @team_leads = User
    .accessible_by(current_ability)
      .where.not(confirmed_at: nil)
      .where(role: 2)
      .order(:last_name)
  
    # 🔹 Locked Accounts
    @users_locked = User
    .accessible_by(current_ability)
      .where(account_active: false)
      .order(:last_name)
  
    # 🔹 Awaiting Email Confirmation
    @users_awaiting_confirmation = User
    .accessible_by(current_ability)
      .where(confirmed_at: nil)
      .order(:created_at)
  end
  
end
