require "rails_helper"

RSpec.describe PaymentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/payments_all").to route_to("payments#index")
    end

    it "routes to #create" do
      expect(:get => "/payments").to route_to("payments#create")
    end

  end
end
