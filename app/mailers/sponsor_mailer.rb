class SponsorMailer < ApplicationMailer
    default from: 'no-reply@netballamerica.com'
    default template_path: 'sponsor_mailer'
   

    def record_allocation_notification
        @sponsor = params[:sponsor]
        
        @email = User.find(@sponsor.user_id).email
        @object_type = @sponsor.class.name
        @record_id =  @sponsor.id
        @old_name = User.find(@sponsor.old_user_id).first_name
        @name = User.find( @sponsor.user_id).first_name
        @link = "https://netball-america-923def44b63e.herokuapp.com/sponsors/#{(@record_id)}/edit?locale=en"
        mail(to: @email, subject: "IMPORTANT: A Sponsor has been allocation to you for action by #{@old_name}.")
      end
    
end
