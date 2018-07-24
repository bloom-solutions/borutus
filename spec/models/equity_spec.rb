require 'spec_helper'

module Borutus
  describe Equity do
    it_behaves_like 'a Borutus::Account subtype', kind: :equity, normal_balance: :credit
  end
end
