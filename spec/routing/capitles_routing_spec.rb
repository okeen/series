require "spec_helper"

describe CapitlesController do
  describe "routing" do

    it "routes to #index" do
      get("/capitles").should route_to("capitles#index")
    end

    it "routes to #new" do
      get("/capitles/new").should route_to("capitles#new")
    end

    it "routes to #show" do
      get("/capitles/1").should route_to("capitles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/capitles/1/edit").should route_to("capitles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/capitles").should route_to("capitles#create")
    end

    it "routes to #update" do
      put("/capitles/1").should route_to("capitles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/capitles/1").should route_to("capitles#destroy", :id => "1")
    end

  end
end
