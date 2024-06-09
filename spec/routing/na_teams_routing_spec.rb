require "rails_helper"

RSpec.describe NaTeamsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/na_teams").to route_to("na_teams#index")
    end

    it "routes to #new" do
      expect(get: "/na_teams/new").to route_to("na_teams#new")
    end

    it "routes to #show" do
      expect(get: "/na_teams/1").to route_to("na_teams#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/na_teams/1/edit").to route_to("na_teams#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/na_teams").to route_to("na_teams#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/na_teams/1").to route_to("na_teams#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/na_teams/1").to route_to("na_teams#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/na_teams/1").to route_to("na_teams#destroy", id: "1")
    end
  end
end
