module Borutus
  # The DebitAmount class represents debit entries in the entry journal.
  #
  # @example
  #     debit_amount = Borutus::DebitAmount.new(:account => cash, :amount => 1000)
  #
  # @author Michael Bulat
  class DebitAmount < ::Borutus::Amount
  end
end
