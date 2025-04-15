require "rails_helper"

RSpec.describe Person, type: :model do
  let(:person) { create(:person) }

  # === 1. Editing fields ===
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
  end

  # === 2. Managing associated records ===
  describe "managing associated records" do
    it "can add and update frequent flyer numbers" do
      person.frequent_flyer_numbers.create(number: "12345", airline: "Delta")
      expect(person.frequent_flyer_numbers.count).to eq(1)

      person.frequent_flyer_numbers.first.update(number: "67890")
      expect(person.frequent_flyer_numbers.first.number).to eq("67890")
    end
  end

  # === 3. Deleting fields and associated records ===
  describe "deleting fields and associated records" do
    it "can delete resume" do
      person.resume = uploaded_test_file("test_resume.pdf", "application/pdf")
      person.save!
      expect {
        person.update!(resume: nil)
      }.to change { person.reload.resume }.from(be_present).to(nil)
    end

    it "can delete certification" do
      person.certification = uploaded_test_file("test_certification.pdf", "application/pdf")
      person.save!
      expect {
        person.update!(certification: nil)
      }.to change { person.reload.certification }.from(be_present).to(nil)
    end

    it "can delete headshot" do
      person.headshot = uploaded_test_file("test_image.png", "image/png")
      person.save!
      expect {
        person.update!(headshot: nil)
      }.to change { person.reload.headshot }.from(be_present).to(nil)
    end

    it "can delete image" do
      person.image = uploaded_test_file("test_image.png", "image/png")
      person.save!
      expect {
        person.update!(image: nil)
      }.to change { person.reload.image }.from(be_present).to(nil)
    end
  end

  # === 4. Validations ===
  it "is not valid without a role" do
    person.role = nil
    expect(person).not_to be_valid
  end

  # === 5. created_at ===
  it "sets created_at automatically" do
    new_person = create(:person)
    expect(new_person.created_at).not_to be_nil
  end
end

