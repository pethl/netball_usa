require "rails_helper"

RSpec.describe SampleWordsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/sample_words").to route_to("sample_words#index")
    end

    it "routes to #new" do
      expect(get: "/sample_words/new").to route_to("sample_words#new")
    end

    it "routes to #show" do
      expect(get: "/sample_words/1").to route_to("sample_words#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/sample_words/1/edit").to route_to("sample_words#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/sample_words").to route_to("sample_words#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/sample_words/1").to route_to("sample_words#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/sample_words/1").to route_to("sample_words#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/sample_words/1").to route_to("sample_words#destroy", id: "1")
    end
  end
end
