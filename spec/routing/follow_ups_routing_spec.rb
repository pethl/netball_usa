require "rails_helper"

RSpec.describe FollowUpsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/follow_ups").to route_to("follow_ups#index")
    end

    it "routes to #new" do
      expect(get: "/follow_ups/new").to route_to("follow_ups#new")
    end

    it "routes to #show" do
      expect(get: "/follow_ups/1").to route_to("follow_ups#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/follow_ups/1/edit").to route_to("follow_ups#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/follow_ups").to route_to("follow_ups#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/follow_ups/1").to route_to("follow_ups#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/follow_ups/1").to route_to("follow_ups#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/follow_ups/1").to route_to("follow_ups#destroy", id: "1")
    end
  end
end
