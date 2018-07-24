require 'spec_helper'

module Borutus
  describe EntriesController do
    routes { Borutus::Engine.routes }

    describe "routing" do
      it "recognizes and generates #index" do
        expect(:get => "/entries").to route_to(:controller => "borutus/entries", :action => "index")
      end
    end
  end
end
