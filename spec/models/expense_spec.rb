require 'spec_helper'

module Borutus
  describe Expense do
    it_behaves_like 'a Borutus::Account subtype', kind: :expense, normal_balance: :debit
  end
end
