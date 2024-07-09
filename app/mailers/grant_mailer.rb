class GrantMailer < Devise::Mailer
    default from: 'no-reply@netballamerica.com'
    default template_path: 'grant_mailer'
   

    def record_allocation_notification
        @grant = params[:grant]
        logger.debug "*******Granthash: #{@grant.attributes.inspect}"
        
        @user = User.find(@grant.user_id)
        @old_user = User.find(@grant.old_user_id)
        @email = @user.email
        @object_type = @grant.class.name
        @record_id =  @grant.id
        @old_name = @old_user.first_name
        @name = @user.first_name
        @link = "https://netball-america-923def44b63e.herokuapp.com/grants/#{(@record_id)}/edit?locale=en"
        mail(to: @email, subject: "IMPORTANT: A Grant has been allocation to you for action by #{@old_name}.")
      end
    
end
