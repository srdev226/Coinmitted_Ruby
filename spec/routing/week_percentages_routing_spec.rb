require "rails_helper"

RSpec.describe WeekPercentagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/week_percentages").to route_to("week_percentages#index")
    end

    it "routes to #new" do
      expect(:get => "/week_percentages/new").to route_to("week_percentages#new")
    end

    it "routes to #show" do
      expect(:get => "/week_percentages/1").to route_to("week_percentages#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/week_percentages/1/edit").to route_to("week_percentages#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/week_percentages").to route_to("week_percentages#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/week_percentages/1").to route_to("week_percentages#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/week_percentages/1").to route_to("week_percentages#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/week_percentages/1").to route_to("week_percentages#destroy", :id => "1")
    end

  end
end
