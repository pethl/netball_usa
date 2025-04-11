require "rails_helper"

RSpec.describe OpportunitiesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/opportunities").to route_to("opportunities#index")
    end

    it "routes to #my_index" do
      expect(get: "/opportunities/my_index").to route_to("opportunities#my_index")
    end

    it "routes to #closed" do
      expect(get: "/opportunities/closed").to route_to("opportunities#closed")
    end
  end
end
