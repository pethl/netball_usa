  require 'rails_helper'

  RSpec.describe User, :type => :model do
    it 'is valid with valid attributes' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end
   
    it 'is invalid without an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to_not be_valid
    end
  
    it 'is invalid without a password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to_not be_valid
    end

    it 'is invalid without first_name' do
      user = FactoryBot.build(:user, first_name: nil)
      expect(user).to_not be_valid
    end

    it 'is invalid without last_name' do
      user = FactoryBot.build(:user, last_name: nil)
      expect(user).to_not be_valid
    end


  end
  
