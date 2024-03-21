require "rails_helper"

RSpec.describe UmpiresController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/umpires").to route_to("umpires#index")
    end

    it "routes to #new" do
      expect(get: "/umpires/new").to route_to("umpires#new")
    end

    it "routes to #show" do
      expect(get: "/umpires/1").to route_to("umpires#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/umpires/1/edit").to route_to("umpires#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/umpires").to route_to("umpires#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/umpires/1").to route_to("umpires#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/umpires/1").to route_to("umpires#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/umpires/1").to route_to("umpires#destroy", id: "1")
    end
  end
end
