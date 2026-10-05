module Admin
  class UsersController < ApplicationController
    before_action :require_admin
    before_action :set_user, only: :send_password_reset

    def new
      @user = User.new
      load_form_options
    end

    def create
      @user = User.new(user_params)
      # Keep the legacy boolean in sync while role remains the primary value.
      @user.admin = @user.role == "admin"
      user_group = selected_user_group

      if params.dig(:user, :user_group_id).blank?
        @user.errors.add(:user_groups, "must include a group")
      elsif user_group.nil?
        @user.errors.add(:user_groups, "is not available")
      end

      if @user.errors.empty? && save_user_with_group(user_group)
        @user.deliver_account_setup_instructions if send_account_email?
        redirect_to users_path, notice: "User account was created#{' and the setup email was queued' if send_account_email?}."
      else
        load_form_options
        render :new, status: :unprocessable_entity
      end
    end

    def send_password_reset
      @user.send_reset_password_instructions

      if @user.errors.empty?
        redirect_to users_path,
                    notice: "Password reset email was sent to #{@user.email}."
      else
        redirect_to users_path,
                    alert: @user.errors.full_messages.to_sentence
      end
    end

    private

    def require_admin
      raise CanCan::AccessDenied unless current_user&.admin?
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :role,
        :user_group_id,
        :send_account_email
      )
    end

    def selected_user_group
      return if @user.user_group_id.blank?

      UserGroup.active.find_by(id: @user.user_group_id)
    end

    def save_user_with_group(user_group)
      User.transaction do
        @user.save!
        @user.user_group_memberships.create!(user_group: user_group)
      end
      true
    rescue ActiveRecord::RecordInvalid => error
      if error.record != @user
        error.record.errors.full_messages.each { |message| @user.errors.add(:user_groups, message) }
      end
      false
    end

    def send_account_email?
      ActiveModel::Type::Boolean.new.cast(@user.send_account_email)
    end

    def load_form_options
      @user_groups = UserGroup.active.ordered
      @role_options = User.roles.keys.map do |role|
        [User.role_description(role), role]
      end
    end
  end
end
