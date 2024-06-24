class OpportunityMailer < ApplicationMailer
    default from: 'no-reply@netballamerica.com'
    default template_path: 'opportunity_mailer'
   

    def record_allocation_notification
      @opportunity =  params[:opportunity]
        
        @email = User.find(@opportunity.user_id).email
        @object_type = @opportunity.class.name
        @sponsor_record_id =  @opportunity.sponsor_id
        @opportunity_record_id =  @opportunity.id
        @old_name = User.find(@opportunity.old_user_id).first_name
        @name = User.find( @opportunity.user_id).first_name
        @link = "https://netball-america-923def44b63e.herokuapp.com/sponsors/#{(@sponsor_record_id)}/opportunities/#{(@opportunity_record_id)}/edit?locale=en"
        mail(to: @email, subject: "IMPORTANT: A Sponsor/Opportunity has been allocation to you for action by #{@old_name}.")
      end
    
end
