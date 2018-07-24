FactoryGirl.define do
  factory :account, :class => Borutus::Account do |account|
    account.name
    account.contra false
  end

  factory :asset, :class => Borutus::Asset do |account|
    account.name
    account.contra false
  end

  factory :equity, :class => Borutus::Equity do |account|
    account.name
    account.contra false
  end

  factory :expense, :class => Borutus::Expense do |account|
    account.name
    account.contra false
  end

  factory :liability, :class => Borutus::Liability do |account|
    account.name
    account.contra false
  end

  factory :revenue, :class => Borutus::Revenue do |account|
    account.name
    account.contra false
  end

  sequence :name do |n|
    "Factory Name #{n}"
  end
end
