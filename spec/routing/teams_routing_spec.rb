require "rails_helper"

RSpec.describe TeamsController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/clubs/1/teams/new").to route_to("teams#new", club_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/clubs/1/teams/1/edit").to route_to("teams#edit", club_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/clubs/1/teams").to route_to("teams#create", club_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/clubs/1/teams/1").to route_to("teams#update", club_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/clubs/1/teams/1").to route_to("teams#update", club_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/clubs/1/teams/1").to route_to("teams#destroy", club_id: "1", id: "1")
    end
  end
end
