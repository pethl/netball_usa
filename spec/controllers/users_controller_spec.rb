require 'spec_helper'
RSpec.describe UsersController, type: :controller do
    # If you have a user factory set up, you can create a user to sign in for tests
    let(:user) { create(:user) }
  
    before do
      # You need to sign the user in for actions that require authentication (like `new`)
      sign_in user
    end
  
    describe "GET #new" do
      it "is successful" do
        get :new
        expect(response).to be_successful # More modern RSpec syntax
      end
    end

    
  context "when user is logged in" do
    it "is successful" do
      sign_in user
      get :new
      expect(response).to be_successful
    end
  end

  context "when user is not logged in" do
    it "redirects to the login page" do
      get :new
      expect(response).to redirect_to(new_user_session_path) # Devise login path
    end
end
  
  end