require 'rails_helper'


RSpec.describe Equipment, type: :model do
  describe "associations" do
    it { should belong_to(:netball_educator) }
  end
end 