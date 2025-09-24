# frozen_string_literal: true
class UserProvisioner
  # Creates or updates a user safely + consistently.
  # - Works whether :confirmable is enabled or not (you currently fake-confirm).
  # - Respects your account_active? gating for login and reset emails.
  # - Ensures first_name/last_name presence (your model requires them).
  #
  # role can be a Symbol (:teamlead) or String ("teamlead").
  def self.create!(
    email:,
    role:,
    first_name:,
    last_name:,
    account_active: true,
    send_reset: true
  )
    User.transaction do
      user = User.find_or_initialize_by(email: email.downcase)

      # Assign essentials your model needs
      user.assign_attributes(
        role: role,                                # enum accepts symbol or string
        first_name: first_name,
        last_name: last_name,
        account_active: account_active
      )

      # Only set a temp password for new users
      if user.new_record?
        tmp = SecureRandom.base58(16)
        user.password = tmp
        user.password_confirmation = tmp

        # You have a custom skip_confirmation! that stamps confirmed_at.
        user.skip_confirmation! if user.respond_to?(:skip_confirmation!)
      end

      user.save!  # will enforce first_name/last_name presence etc.

      # Send reset only if you want the user to set their own password
      # and only if the account is active (your override enforces this anyway).
      if send_reset
        res = user.send_reset_password_instructions
        if res.is_a?(User) && res.errors.any?
          # Surface your "inactive account" style error if it happens
          raise ActiveRecord::RecordInvalid.new(user), res.errors.full_messages.to_sentence
        end
      end

      user
    end
  end
end
