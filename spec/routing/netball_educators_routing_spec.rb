require "rails_helper"

RSpec.describe NetballEducatorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/netball_educators").to route_to("netball_educators#index")
    end

    it "routes to #new" do
      expect(get: "/netball_educators/new").to route_to("netball_educators#new")
    end

    it "routes to #show" do
      expect(get: "/netball_educators/1").to route_to("netball_educators#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/netball_educators/1/edit").to route_to("netball_educators#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/netball_educators").to route_to("netball_educators#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/netball_educators/1").to route_to("netball_educators#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/netball_educators/1").to route_to("netball_educators#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/netball_educators/1").to route_to("netball_educators#destroy", id: "1")
    end
  end
end
