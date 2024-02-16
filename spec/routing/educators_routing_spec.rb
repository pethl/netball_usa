require "rails_helper"

RSpec.describe EducatorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/educators").to route_to("educators#index")
    end

    it "routes to #new" do
      expect(get: "/educators/new").to route_to("educators#new")
    end

    it "routes to #show" do
      expect(get: "/educators/1").to route_to("educators#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/educators/1/edit").to route_to("educators#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/educators").to route_to("educators#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/educators/1").to route_to("educators#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/educators/1").to route_to("educators#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/educators/1").to route_to("educators#destroy", id: "1")
    end
  end
end
