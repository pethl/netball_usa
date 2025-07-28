require "rails_helper"

RSpec.describe NetballAcademiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/netball_academies").to route_to("netball_academies#index")
    end

    it "routes to #new" do
      expect(get: "/netball_academies/new").to route_to("netball_academies#new")
    end

    it "routes to #show" do
      expect(get: "/netball_academies/1").to route_to("netball_academies#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/netball_academies/1/edit").to route_to("netball_academies#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/netball_academies").to route_to("netball_academies#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/netball_academies/1").to route_to("netball_academies#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/netball_academies/1").to route_to("netball_academies#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/netball_academies/1").to route_to("netball_academies#destroy", id: "1")
    end
  end
end
