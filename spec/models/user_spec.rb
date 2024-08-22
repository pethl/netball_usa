require 'rails_helper'

  RSpec.describe User, :type => :model do
    subject {
      described_class.new(first_name: "Meg  ",
                          last_name: "Ryan",
                          email: "meg@ryan.com",
                          password: "foobar",
                          password_confirmation: "foobar"
                          )
    }


    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  
    it "is not valid without a first name" do
      subject.first_name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a last_name" do
      subject.last_name = nil
      expect(subject).to_not be_valid
    end
    
    it "is not valid without a email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a password" do
      subject.password = nil
      expect(subject).to_not be_valid
    end

    # it "is not valid without a password_confirmation" do
    #   subject.password_confirmation = nil
    #   expect(subject).to_not be_valid
    # end

  end
  
