class UserGroupsController < ApplicationController
  before_action :require_admin

  def show
    @user_group = UserGroup.find_by!(key: params[:key])

    @members = @user_group
      .users
      .order(:first_name, :last_name)

    @memberships = @user_group
      .user_group_memberships
      .includes(:user)

    @available_users = User
      .where(account_active: true)
      .where.not(id: @members.select(:id))
      .order(:first_name, :last_name)
  end

  private

  def require_admin
    raise CanCan::AccessDenied unless current_user&.admin?
  end
end