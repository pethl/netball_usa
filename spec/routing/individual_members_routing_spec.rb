require "rails_helper"

RSpec.describe IndividualMembersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/individual_members").to route_to("individual_members#index")
    end

    it "routes to #new" do
      expect(get: "/individual_members/new").to route_to("individual_members#new")
    end

    it "routes to #show" do
      expect(get: "/individual_members/1").to route_to("individual_members#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/individual_members/1/edit").to route_to("individual_members#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/individual_members").to route_to("individual_members#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/individual_members/1").to route_to("individual_members#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/individual_members/1").to route_to("individual_members#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/individual_members/1").to route_to("individual_members#destroy", id: "1")
    end
  end
end
