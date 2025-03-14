require 'rails_helper'

RSpec.describe Medium, type: :model do
  # Associations
  it { should belong_to(:user).optional } # Assuming media can have a user but it's not required

  # Validations
  it { should validate_presence_of(:media_type) }
  it { should validate_presence_of(:company_name) }
  # it { should validate_presence_of(:contact_name) }
  # it { should validate_presence_of(:email) }
  # it { should validate_presence_of(:phone) }
  # it { should validate_presence_of(:country) }

  # Email format validation
  # it "validates email format" do
  #   media = Media.new(email: "invalid_email")
  #   media.valid?
  #   expect(media.errors[:email]).to include("is invalid") # Assuming format validation exists
  # end

  # # URL validation for company website
  # it "allows valid URLs for company_website" do
  #   media = Media.new(company_website: "https://validwebsite.com")
  #   media.valid?
  #   expect(media.errors[:company_website]).to be_empty
  # end

  # it "rejects invalid URLs for company_website" do
  #   media = Media.new(company_website: "not_a_url")
  #   media.valid?
  #   expect(media.errors[:company_website]).to include("is invalid") # Assuming validation exists
  # end
end
