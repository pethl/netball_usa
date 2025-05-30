require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/individual_members", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # IndividualMember. As you add validations to IndividualMember, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      IndividualMember.create! valid_attributes
      get individual_members_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      individual_member = IndividualMember.create! valid_attributes
      get individual_member_url(individual_member)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_individual_member_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      individual_member = IndividualMember.create! valid_attributes
      get edit_individual_member_url(individual_member)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new IndividualMember" do
        expect {
          post individual_members_url, params: { individual_member: valid_attributes }
        }.to change(IndividualMember, :count).by(1)
      end

      it "redirects to the created individual_member" do
        post individual_members_url, params: { individual_member: valid_attributes }
        expect(response).to redirect_to(individual_member_url(IndividualMember.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new IndividualMember" do
        expect {
          post individual_members_url, params: { individual_member: invalid_attributes }
        }.to change(IndividualMember, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post individual_members_url, params: { individual_member: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested individual_member" do
        individual_member = IndividualMember.create! valid_attributes
        patch individual_member_url(individual_member), params: { individual_member: new_attributes }
        individual_member.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the individual_member" do
        individual_member = IndividualMember.create! valid_attributes
        patch individual_member_url(individual_member), params: { individual_member: new_attributes }
        individual_member.reload
        expect(response).to redirect_to(individual_member_url(individual_member))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        individual_member = IndividualMember.create! valid_attributes
        patch individual_member_url(individual_member), params: { individual_member: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested individual_member" do
      individual_member = IndividualMember.create! valid_attributes
      expect {
        delete individual_member_url(individual_member)
      }.to change(IndividualMember, :count).by(-1)
    end

    it "redirects to the individual_members list" do
      individual_member = IndividualMember.create! valid_attributes
      delete individual_member_url(individual_member)
      expect(response).to redirect_to(individual_members_url)
    end
  end
end
