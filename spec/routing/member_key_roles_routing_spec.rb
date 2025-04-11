require "rails_helper"

RSpec.describe MemberKeyRolesController, type: :routing do
  describe "routing" do
    it "routes to #new" do
      expect(get: "/clubs/1/member_key_roles/new").to route_to("member_key_roles#new", club_id: "1")
    end

    it "routes to #edit" do
      expect(get: "/clubs/1/member_key_roles/1/edit").to route_to("member_key_roles#edit", club_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post: "/clubs/1/member_key_roles").to route_to("member_key_roles#create", club_id: "1")
    end

    it "routes to #update via PUT" do
      expect(put: "/clubs/1/member_key_roles/1").to route_to("member_key_roles#update", club_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/clubs/1/member_key_roles/1").to route_to("member_key_roles#update", club_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/clubs/1/member_key_roles/1").to route_to("member_key_roles#destroy", club_id: "1", id: "1")
    end
  end
end

