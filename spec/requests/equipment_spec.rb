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

RSpec.describe "/equipment", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Equipment. As you add validations to Equipment, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Equipment.create! valid_attributes
      get equipment_index_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      equipment = Equipment.create! valid_attributes
      get equipment_url(equipment)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_equipment_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      equipment = Equipment.create! valid_attributes
      get edit_equipment_url(equipment)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Equipment" do
        expect {
          post equipment_index_url, params: { equipment: valid_attributes }
        }.to change(Equipment, :count).by(1)
      end

      it "redirects to the created equipment" do
        post equipment_index_url, params: { equipment: valid_attributes }
        expect(response).to redirect_to(equipment_url(Equipment.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Equipment" do
        expect {
          post equipment_index_url, params: { equipment: invalid_attributes }
        }.to change(Equipment, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post equipment_index_url, params: { equipment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested equipment" do
        equipment = Equipment.create! valid_attributes
        patch equipment_url(equipment), params: { equipment: new_attributes }
        equipment.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the equipment" do
        equipment = Equipment.create! valid_attributes
        patch equipment_url(equipment), params: { equipment: new_attributes }
        equipment.reload
        expect(response).to redirect_to(equipment_url(equipment))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        equipment = Equipment.create! valid_attributes
        patch equipment_url(equipment), params: { equipment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested equipment" do
      equipment = Equipment.create! valid_attributes
      expect {
        delete equipment_url(equipment)
      }.to change(Equipment, :count).by(-1)
    end

    it "redirects to the equipment list" do
      equipment = Equipment.create! valid_attributes
      delete equipment_url(equipment)
      expect(response).to redirect_to(equipment_index_url)
    end
  end
end