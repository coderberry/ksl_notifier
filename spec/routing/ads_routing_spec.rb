require "spec_helper"

describe AdsController do
  describe "routing" do

    it "routes to #index" do
      get("/ads").should route_to("ads#index")
    end

    it "routes to #new" do
      get("/ads/new").should route_to("ads#new")
    end

    it "routes to #show" do
      get("/ads/1").should route_to("ads#show", :id => "1")
    end

    it "routes to #edit" do
      get("/ads/1/edit").should route_to("ads#edit", :id => "1")
    end

    it "routes to #create" do
      post("/ads").should route_to("ads#create")
    end

    it "routes to #update" do
      put("/ads/1").should route_to("ads#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/ads/1").should route_to("ads#destroy", :id => "1")
    end

  end
end
