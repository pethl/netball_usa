require "rails_helper"

RSpec.describe EventsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/events").to route_to("events#index")
    end

    it "routes to #new" do
      expect(get: "/events/new").to route_to("events#new")
    end

    it "routes to #show" do
      expect(get: "/events/1").to route_to("events#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/events/1/edit").to route_to("events#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/events").to route_to("events#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/events/1").to route_to("events#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/events/1").to route_to("events#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/events/1").to route_to("events#destroy", id: "1")
    end

    it "routes to #calendar" do
      expect(get: "/events/calendar").to route_to("events#calendar")
    end
  end
end

