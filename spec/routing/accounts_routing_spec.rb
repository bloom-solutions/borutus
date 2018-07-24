require 'spec_helper'

module Borutus
  describe AccountsController do
    routes { Borutus::Engine.routes }

    describe "routing" do
      it "recognizes and generates #index" do
        expect(:get => "/accounts").to route_to(:controller => "borutus/accounts", :action => "index")
      end
    end
  end
end
