require "rails_helper"

RSpec.describe PhoneNumbersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/phone_numbers").to route_to("phone_numbers#index")
    end

    it "routes to #new" do
      expect(:get => "/phone_numbers/new").to route_to("phone_numbers#new")
    end

    it "routes to #show" do
      expect(:get => "/phone_numbers/1").to route_to("phone_numbers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/phone_numbers/1/edit").to route_to("phone_numbers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/phone_numbers").to route_to("phone_numbers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/phone_numbers/1").to route_to("phone_numbers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/phone_numbers/1").to route_to("phone_numbers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/phone_numbers/1").to route_to("phone_numbers#destroy", :id => "1")
    end

  end
end
