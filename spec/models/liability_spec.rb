require 'spec_helper'

module Borutus
  describe Liability do
    it_behaves_like 'a Borutus::Account subtype', kind: :liability, normal_balance: :credit
  end
end
