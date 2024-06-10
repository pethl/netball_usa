class UsersController < ApplicationController
  def index
    authorize! :read, @users
    @users = User.where.not(confirmed_at: nil)
    @users = @users.order(role: :asc)
    @users_awaiting_confirmation = User.where(confirmed_at: nil)
    @users_awaiting_confirmation= @users_awaiting_confirmation.order(created_at: :asc)
 #  @users_awaiting_approval = User.where(approved: false)
 #  @users_awaiting_approval= @users_awaiting_approval.order(created_at: :asc)
  end
end
