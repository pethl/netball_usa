# app/mailers/event_mailer.rb
class EventMailer < ApplicationMailer
  def assignment_email(user, event)
    @event = event
    @user = user

    mail(
      to: user.email,
      subject: "Event assigned to you: #{@event.name}"
    )
  end
end
