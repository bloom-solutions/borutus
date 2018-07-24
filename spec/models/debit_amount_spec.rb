require 'spec_helper'

module Borutus
  describe DebitAmount do
    it_behaves_like 'a Borutus::Amount subtype', kind: :debit_amount
  end
end
