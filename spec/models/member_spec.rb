require 'rails_helper'

RSpec.describe Member, type: :model do
  subject { Member.new(first_name: "Carina", last_name: "Allen", email:"carinaAllen@gmail.com", team_id: 1 )}
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a first_name" do
      subject.first_name=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a last_name" do
      subject.last_name=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a email" do
      subject.email=nil
      expect(subject).to_not be_valid
    end
   
end
