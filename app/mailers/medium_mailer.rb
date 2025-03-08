class MediumMailer < ApplicationMailer
    default from: 'no-reply@netballamerica.com'
    default template_path: 'medium_mailer'
   

    def record_allocation_notification
      @medium =  params[:medium]
        
        @email = User.find(@medium.user_id).email
        @object_type = @medium.class.name
        @media_id =  @medium.id
        @company_name =  @medium.company_name
        @old_name = User.find(@medium.old_user_id).first_name
        @name = User.find( @medium.user_id).first_name
        @link = "https://netball-america-923def44b63e.herokuapp.com/media/#{(@media_id)}/edit?locale=en"
        mail(to: @email, subject: "IMPORTANT: A Media record has been allocation to you for action by #{@old_name}.")
      end
    
end
