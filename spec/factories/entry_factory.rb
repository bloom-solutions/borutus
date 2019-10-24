FactoryBot.define do
  factory :entry, class: Borutus::Entry do
    description { "factory description" }
  end

  factory :entry_with_credit_and_debit, class: Borutus::Entry do
    description { "factory description" }
    
    after(:build) do |entry|
      entry.credit_amounts << FactoryBot.build(:credit_amount, entry: entry)
      entry.debit_amounts << FactoryBot.build(:debit_amount, entry: entry)
    end
  end
end
