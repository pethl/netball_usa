class PagesController < ApplicationController
  before_action :get_users, only: [:rolodex]
  def home
  end
  
  def rolodex
  end
  
  private

    def get_users
       @users = User.all
    end
end
