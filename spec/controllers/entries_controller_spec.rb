require 'spec_helper'

module Borutus
  describe EntriesController do
    routes { Borutus::Engine.routes }

    def mock_entry(stubs={})
      @mock_entry ||= FactoryBot.create(:entry_with_credit_and_debit)
    end

    describe "GET index" do
      it "assigns all entries as @entries" do
        allow(Entry).to receive_message_chain(:per, :order).and_return([mock_entry])
        get :index
        expect(assigns[:entries]).to eq([mock_entry])
      end
    end
  end
end
