require 'rails_helper'

RSpec.describe Grant, type: :model do
  subject { Grant.new(name: "Women's Sports Foundation - Travel & Training Grant", status: "In Progress", apply: true, amount: 5000, location: "national", state: "MI", due_date: "2024-06-20T17:00:00.000Z", timezone: "Eastern", user_id:10 )}
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a name" do
      subject.name=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a status" do
      subject.status=nil
      expect(subject).to_not be_valid
    end
  
end
