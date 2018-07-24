module Borutus
  # The CreditAmount class represents credit entries in the entry journal.
  #
  # @example
  #     credit_amount = Borutus::CreditAmount.new(:account => revenue, :amount => 1000)
  #
  # @author Michael Bulat
  class CreditAmount < ::Borutus::Amount
  end
end
