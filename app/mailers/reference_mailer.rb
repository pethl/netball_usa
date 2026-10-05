class ReferenceMailer < ApplicationMailer
   # default from: 'no-reply@netballamerica.com'
    default template_path: 'reference_mailer'

    def new_reference_email
        @reference = params[:reference]

        mail(
          to: "pethicklisa@gmail.com",
          subject: "New Netball America reference data created"
        )
    end

    def update_reference_email
        @reference = params[:reference]
        @email = "pethicklisa@gmail.com"
    
        mail(to: @email, subject: "NETBALL_AMERICA: Reference Updated!")
    end
end
