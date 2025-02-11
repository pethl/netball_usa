require 'rails_helper'

RSpec.describe Person, type: :model do
  let(:person) { create(:person) }
  let(:frequent_flyer_number) { create(:frequent_flyer_number) }
  
  # 1. Test editing fields on the Person model
  describe "editing fields" do
    it "can update first_name" do
      new_name = "New First Name"
      person.update(first_name: new_name)
      expect(person.reload.first_name).to eq(new_name)
    end
    
    it "can update last_name" do
      new_name = "New Last Name"
      person.update(last_name: new_name)
      expect(person.reload.last_name).to eq(new_name)
    end
    
    it "can update email" do
      new_email = "new_email@example.com"
      person.update(email: new_email)
      expect(person.reload.email).to eq(new_email)
    end
    
    it "can update role" do
      new_role = "New Role"
      person.update(role: new_role)
      expect(person.reload.role).to eq(new_role)
    end

    describe "Person editing fields" do
      it "can update frequent flyer numbers" do
        person = create(:person)
        expect(person.frequent_flyer_numbers.count).to eq(0)  # Make sure there are no FFNs initially
    
        # Add a FrequentFlyerNumber
        person.frequent_flyer_numbers.create(number: "12345", airline: "delta")
    
        # Check that it was added correctly
        expect(person.frequent_flyer_numbers.count).to eq(1)
      end
    end
    
    it "can update frequent flyer numbers" do
      # Add a new frequent flyer number
      person.frequent_flyer_numbers.create(number: "12345")
      expect(person.frequent_flyer_numbers.count).to eq(1)
      
      # Edit an existing frequent flyer number
      person.frequent_flyer_numbers.first.update(number: "67890")
      expect(person.frequent_flyer_numbers.first.number).to eq("67890")
    end
  end
  
  # 2. Test deleting associated records
  describe "deleting fields and associated records" do
    it "can delete frequent flyer number" do
      ffn = person.frequent_flyer_numbers.create(number: "12345")
      expect { ffn.destroy }.to change { person.frequent_flyer_numbers.count }.by(-1)
    end
    
    it "can delete image" do
      person.image = File.open(Rails.root.join("spec/fixtures/files/test_image.png"))
      person.save
      expect { person.image.destroy }.to change { person.reload.image.present? }.from(true).to(false)
    end

    it "can delete headshot" do
      person.headshot = File.open(Rails.root.join("spec/fixtures/files/test_image.png"))
      person.save
      expect { person.headshot.destroy }.to change { person.reload.headshot.present? }.from(true).to(false)
    end

    it "can delete certification" do
      person.certification = File.open(Rails.root.join("spec/fixtures/files/test_certification.pdf"))
      person.save
      expect { person.certification.destroy }.to change { person.reload.certification.present? }.from(true).to(false)
    end
    
    it "can delete resume" do
      person.resume = File.open(Rails.root.join("spec/fixtures/files/test_resume.pdf"))
      person.save
      expect { person.resume.destroy }.to change { person.reload.resume.present? }.from(true).to(false)
    end
  end
  
  # 3. Ensure the role field is required and doesn't allow null values
  it "is not valid without a role" do
    person.role = nil
    expect(person).not_to be_valid
  end
end