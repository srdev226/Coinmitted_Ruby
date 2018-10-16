require "rails_helper"

RSpec.describe NumberVerificationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/number_verifications").to route_to("number_verifications#index")
    end

    it "routes to #new" do
      expect(:get => "/number_verifications/new").to route_to("number_verifications#new")
    end

    it "routes to #show" do
      expect(:get => "/number_verifications/1").to route_to("number_verifications#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/number_verifications/1/edit").to route_to("number_verifications#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/number_verifications").to route_to("number_verifications#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/number_verifications/1").to route_to("number_verifications#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/number_verifications/1").to route_to("number_verifications#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/number_verifications/1").to route_to("number_verifications#destroy", :id => "1")
    end

  end
end
