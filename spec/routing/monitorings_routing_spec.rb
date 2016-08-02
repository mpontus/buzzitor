require "rails_helper"

RSpec.describe MonitoringsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/monitorings").to route_to("monitorings#index")
    end

    it "routes to #new" do
      expect(:get => "/monitorings/new").to route_to("monitorings#new")
    end

    it "routes to #show" do
      expect(:get => "/monitorings/1").to route_to("monitorings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/monitorings/1/edit").to route_to("monitorings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/monitorings").to route_to("monitorings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/monitorings/1").to route_to("monitorings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/monitorings/1").to route_to("monitorings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/monitorings/1").to route_to("monitorings#destroy", :id => "1")
    end

  end
end
