class UserMailerPreview < ActionMailer::Preview
    def new_reference_email
        # Call your mailer method and pass any arguments it requires
        ReferenceMailer.new_reference_email(Reference.first)
    end
end