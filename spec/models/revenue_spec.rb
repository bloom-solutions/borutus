require 'spec_helper'

module Borutus
  describe Revenue do
    it_behaves_like 'a Borutus::Account subtype', kind: :revenue, normal_balance: :credit
  end
end
