class UsersController < ApplicationController
  def index
    @users = User.all
    @users = @users.order(created_at: :asc)
  end
end
