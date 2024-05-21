require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { Team.new(name: "Seattle Scorcers", city: "Seattle", state:"OR", user_id: 10 )}
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a name" do
      subject.name=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a city" do
      subject.city=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a state" do
      subject.state=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a state" do
      subject.state=nil
      expect(subject).to_not be_valid
    end
end
