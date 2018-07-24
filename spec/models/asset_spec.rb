require 'spec_helper'

module Borutus
  describe Asset do
    it_behaves_like 'a Borutus::Account subtype', kind: :asset, normal_balance: :debit
  end
end
