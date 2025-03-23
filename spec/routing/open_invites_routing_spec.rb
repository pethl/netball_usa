require "rails_helper"

RSpec.describe OpenInvitesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/open_invites").to route_to("open_invites#index")
    end

    it "routes to #new" do
      expect(get: "/open_invites/new").to route_to("open_invites#new")
    end

    it "routes to #show" do
      expect(get: "/open_invites/1").to route_to("open_invites#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/open_invites/1/edit").to route_to("open_invites#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/open_invites").to route_to("open_invites#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/open_invites/1").to route_to("open_invites#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/open_invites/1").to route_to("open_invites#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/open_invites/1").to route_to("open_invites#destroy", id: "1")
    end
  end
end
