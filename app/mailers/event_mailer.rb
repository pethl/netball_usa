# app/mailers/event_mailer.rb
class EventMailer < ApplicationMailer
  def assignment_email(user, event)
    @event = event
    @user = user
    @assigner = Current.user # Make sure you're using `Current.user` in your app

    mail(to: user.email, subject: "You've been assigned a new event: #{@event.name}")
  end
end
