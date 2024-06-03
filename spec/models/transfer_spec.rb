require 'rails_helper'


RSpec.describe Transfer, type: :model do
  subject { Transfer.new(first_name: "Janet ", last_name: "Tester", role:"Scorer", check_in:"01/01/2024", check_out:"03/01/2024")}
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a first name" do
      subject.first_name=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a last name" do
      subject.last_name=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a role" do
      subject.role=nil
      expect(subject).to_not be_valid
    end
    it "is not valid if check in is before cheeck out" do
      subject.check_out=subject.check_in
      expect(subject).to_not be_valid
    end
end
