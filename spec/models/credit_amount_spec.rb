require 'spec_helper'

module Borutus
  describe CreditAmount do
    it_behaves_like 'a Borutus::Amount subtype', kind: :credit_amount
  end
end
