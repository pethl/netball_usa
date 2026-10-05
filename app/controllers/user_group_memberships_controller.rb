class UserGroupMembershipsController < ApplicationController
  before_action :require_admin
  before_action :set_user_group, only: :create
  before_action :set_membership, only: :destroy

  def create
  membership = @user_group.user_group_memberships.new(
    membership_params
  )

  if membership.save
    redirect_to membership_return_path(@user_group),
                notice: "User was added to the group."
  else
    redirect_to membership_return_path(@user_group),
                alert: membership.errors.full_messages.to_sentence
  end
end

def destroy
  user_group = @membership.user_group

  @membership.destroy

  redirect_to membership_return_path(user_group),
              notice: "User was removed from the group.",
              status: :see_other
end

  private

  def set_user_group
    @user_group = UserGroup.find_by!(
      key: params[:user_group_key]
    )
  end

  def set_membership
    @membership = UserGroupMembership.find(params[:id])
  end

  def membership_params
    params.require(:user_group_membership).permit(:user_id)
  end

  def require_admin
    raise CanCan::AccessDenied unless current_user&.admin?
  end

  def membership_return_path(user_group)
    if params[:return_to] == "index"
      user_groups_path
    else
      user_group_path(user_group.key)
    end
  end
end