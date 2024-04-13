class UsersController < ApplicationController
  def index
    @users = User.where(approved: true)
    @users = @users.order(created_at: :asc)
    @users_awaiting_approval = User.where(approved: false)
    @users_awaiting_approval= @users_awaiting_approval.order(created_at: :asc)
  end
end
