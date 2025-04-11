require "rails_helper"

RSpec.describe MembersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/members").to route_to("members#index")
    end
  end
end

