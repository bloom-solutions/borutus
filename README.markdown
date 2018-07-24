Borutus
=================
[![Build Status](https://travis-ci.org/bloom-solutions/borutus.svg?branch=master)](https://travis-ci.org/bloom-solutions/borutus)

Borutus is based on the `bloom_changes` branch of [bloom-solutions/plutus](https://github.com/bloom-solutions/plutus), which is a fork of
[mbulat/plutus](https://github.com/mbulat/plutus).

The Borutus plugin is a Ruby on Rails Engine which provides a double entry accounting system for your application.

Compatibility
=============

* Ruby versions: MRI 2.2.2+
* Rails versions: ~> 5.0

Installation
============

- Add the gem to your Gemfile `gem "borutus"`
- generate migration files `rake borutus:install:migrations`
- run migrations `rake db:migrate`

Overview
========

The borutus plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general [Double Entry Bookkeeping](http://en.wikipedia.org/wiki/Double-entry_bookkeeping_system) practices. All calculations are done using [BigDecimal](http://www.ruby-doc.org/stdlib-2.1.0/libdoc/bigdecimal/rdoc/BigDecimal.html) in order to prevent floating point rounding errors. The plugin requires a decimal type on your database as well.

Borutus consists of tables that maintain your accounts, entries and debits and credits. Each entry can have many debits and credits. The entry table, which records your business transactions is, essentially, your accounting  [Journal](http://en.wikipedia.org/wiki/Journal_entry).

Posting to a [Ledger](http://en.wikipedia.org/wiki/General_ledger) can be considered to happen automatically, since Accounts have the reverse `has_many` relationship to either its credit or debit entries.

Accounts
--------

The Account class represents accounts in the system. The Account table uses single table inheritance to store information on each type of account (Asset, Liability, Equity, Revenue, Expense). Each account must be sub-classed as one of the following types:

    TYPE        | NORMAL BALANCE    | DESCRIPTION
    --------------------------------------------------------------------------
    Asset       | Debit             | Resources owned by the Business Entity
    Liability   | Credit            | Debts owed to outsiders
    Equity      | Credit            | Owners rights to the Assets
    Revenue     | Credit            | Increases in owners equity
    Expense     | Debit             | Assets or services consumed in the generation of revenue

Your Book of Accounts needs to be created prior to recording any entries. The simplest method is to have a number of `create` methods in your db/seeds.rb file like so:

```ruby
Borutus::Asset.create(:name => "Accounts Receivable")
Borutus::Asset.create(:name => "Cash")
Borutus::Revenue.create(:name => "Sales Revenue")
Borutus::Liability.create(:name => "Unearned Revenue")
Borutus::Liability.create(:name => "Sales Tax Payable")
```

Then simply run `rake db:seed`

Each account can also be marked as a "Contra Account". A contra account will have its normal balance swapped. For example, to remove equity, a "Drawing" account may be created as a contra equity account as follows:

```ruby
Borutus::Equity.create(:name => "Drawing", :contra => true)
```

At all times the balance of all accounts should conform to the [Accounting
Equation](http://en.wikipedia.org/wiki/Accounting_equation)

    Assets = Liabilities + Owner's Equity

Every account object has a `has_many` association of credit and debit entries, which means that each account object also acts as its own [Ledger](http://en.wikipedia.org/wiki/General_ledger), and exposes a method to calculate the balance of the account.

See the `Borutus::Account`, `Borutus::Entry`, and `Borutus::Amount` classes for more information.

Examples
========

Recording an Entry
------------------

Let's assume we're accounting on an [Accrual basis](http://en.wikipedia.org/wiki/Accounting_methods#Accrual_basis). We've just taken a customer's order for some widgets, which we've also billed him for. At this point we've actually added a liability to the company until we deliver the goods. To record this entry we'd need two accounts:

```ruby
>> Borutus::Asset.create(:name => "Cash")
>> Borutus::Liability.create(:name => "Unearned Revenue")
```

Next we'll build the entry we want to record. Borutus uses ActiveRecord conventions to build the transaction and its associated amounts.

```ruby
entry = Borutus::Entry.new(
                :description => "Order placed for widgets",
                :date => Date.yesterday,
                :debits => [
                  {:account_name => "Cash", :amount => 100.00}],
                :credits => [
                  {:account_name => "Unearned Revenue", :amount => 100.00}])
```

Entries must specify a description, as well as at least one credit and debit amount. Specifying the date is optional; by default, the current date will be assigned to the entry before the record is saved. `debits` and `credits` must specify an array of hashes, with an amount value as well as an account, either by providing a `Borutus::Account` to `account` or by passing in an `account_name` string.

Finally, save the entry.

```ruby
>> entry.save
```

If there are any issues with your credit and debit amounts, the save will fail and return false. You can inspect the errors via `entry.errors`. Because we are doing double-entry accounting, the sum total of your credit and debit amounts must always cancel out to keep the accounts in balance.

Recording an Entry with multiple accounts
-----------------------------------------

Often times a single entry requires more than one type of account. A classic example would be a entry in which a tax is charged. We'll assume that we have not yet received payment for the order, so we'll need an "Accounts Receivable" Asset:

```ruby
>> Borutus::Asset.create(:name => "Accounts Receivable")
>> Borutus::Revenue.create(:name => "Sales Revenue")
>> Borutus::Liability.create(:name => "Sales Tax Payable")
```

And here's the entry:

```ruby
entry = Borutus::Entry.build(
                :description => "Sold some widgets",
                :debits => [
                  {:account_name => "Accounts Receivable", :amount => 50}],
                :credits => [
                  {:account_name => "Sales Revenue", :amount => 45},
                  {:account_name => "Sales Tax Payable", :amount => 5}])
entry.save
```

Associating Documents
---------------------

Although Borutus does not provide a mechanism for generating invoices or orders, it is possible to associate any such commercial document with a given entry.

Suppose we pull up our latest invoice in order to generate a entry for borutus (we'll assume you already have an Invoice model):

```ruby
>> invoice = Invoice.last
```

Let's assume we're using the same entry from the last example

```ruby
entry = Borutus::Entry.new(
                :description => "Sold some widgets",
                :commercial_document => invoice,
                :debits => [
                  {:account_name => "Accounts Receivable", :amount => invoice.total_amount}],
                :credits => [
                  {:account_name => "Sales Revenue", :amount => invoice.sales_amount},
                  {:account_name => "Sales Tax Payable", :amount => invoice.tax_amount}])
entry.save
```

The commercial document attribute on the entry is a polymorphic association allowing you to associate any record from your models with a entry (i.e. Bills, Invoices, Receipts, Returns, etc.)

Checking the Balance of an  Individual Account
----------------------------------------------

Each account can report on its own balance. This number should normally be positive. If the number is negative, you may have a problem.

```ruby
>> cash = Borutus::Asset.find_by_name("Cash")
>> cash.balance
=> #<BigDecimal:103259bb8,'0.2E4',4(12)>
```

The balance can also be calculated within a specified date range. Dates can be strings in the format of "yyyy-mm-dd" or Ruby Date objects.

```ruby
>> cash = Borutus::Asset.find_by_name("Cash")
>> cash.balance(:from_date => "2014-01-01", :to_date => Date.today)
=> #<BigDecimal:103259bb8,'0.2E4',4(12)>
```

Checking the Balance of an Account Type
---------------------------------------

Each subclass of accounts can report on the total balance of all the accounts of that type. This number should normally be positive. If the number is negative, you may have a problem.

```ruby
>> Borutus::Asset.balance
=> #<BigDecimal:103259bb8,'0.2E4',4(12)>
```

Again, a date range can be given

```ruby
>> Borutus::Asset.balance(:from_date => "2014-01-01", :to_date => Date.today)
=> #<BigDecimal:103259bb8,'0.2E4',4(12)>
```

Calculating the Trial Balance
-----------------------------

The [Trial Balance](http://en.wikipedia.org/wiki/Trial_balance) for all accounts on the system can be found through the abstract Account class. This value should be 0 unless there is an error in the system.

```ruby
>> Borutus::Account.trial_balance
=> #<BigDecimal:1031c0d28,'0.0',4(12)>
```

Contra Accounts and Complex Entries
-----------------------------------

For complex entries, you should always ensure that you are balancing your accounts via the [Accounting Equation](http://en.wikipedia.org/wiki/Accounting_equation).

    Assets = Liabilities + Owner's Equity

For example, let's assume the owner of a business wants to withdraw cash. First we'll assume that we have an asset account for "Cash" which the funds will be drawn from. We'll then need an Equity account to record where the funds are going, however, in this case, we can't simply create a regular Equity account. The "Cash" account must be credited for the decrease in its balance since it's an Asset. Likewise, Equity accounts are typically credited when there is an increase in their balance. Equity is considered an owner's rights to Assets in the business. In this case however, we are not simply increasing the owner's rights to assets within the business; we are actually removing capital from the business altogether. Hence both sides of our accounting equation will see a decrease. In order to accomplish this, we need to create a Contra-Equity account we'll call "Drawings". Since Equity accounts normally have credit balances, a Contra-Equity account will have a debit balance, which is what we need for our entry.

```ruby
>> Borutus::Equity.create(:name => "Drawing", :contra => true)
>> Borutus::Asset.create(:name => "Cash")
```

We would then create the following entry:

```ruby
entry = Borutus::Entry.new(
                :description => "Owner withdrawing cash",
                :debits => [
                  {:account_name => "Drawing", :amount => 1000}],
                :credits => [
                  {:account_name => "Cash", :amount => 1000}])
entry.save
```

To make the example clearer, imagine instead that the owner decides to invest his money into the business in exchange for some type of equity security. In this case we might have the following accounts:

```ruby
>> Borutus::Equity.create(:name => "Common Stock")
>> Borutus::Asset.create(:name => "Cash")
```

And out entry would be:

```ruby
entry = Borutus::Entry.new(
                :description => "Owner investing cash",
                :debits => [
                  {:account_name => "Cash", :amount => 1000}],
                :credits => [
                  {:account_name => "Common Stock", :amount => 1000}])
entry.save
```

In this case, we've increase our cash Asset, and simultaneously increased the other side of our accounting equation in
Equity, keeping everything balanced.

Money & Currency Support
========================

Borutus aims to be agnostic about the values used for amounts. All fields are maintained as BigDecimal values, with `:precision => 20, :scale => 10`, which means that any currency can be safely stored in the tables.

Borutus is also compatible with the [Money](https://github.com/RubyMoney/money) gem. With Money versions greater than 6.0, the `money.amount` will returns a BigDecimal which you can use with borutus as follows:

```ruby
entry = Borutus::Entry.build(
                :description => "Order placed for widgets",
                :debits => [
                  {:account_name => "Cash", :amount => money.amount}],
                :credits => [
                  {:account_name => "Unearned Revenue", :amount => money.amount}])
```

Multitenancy Support
=====================

Borutus supports multitenant applications. Multitenancy is acheived by associating all Accounts under `Borutus::Account` with a "Tenant" object (typically some model in your Rails application). To add multi-tenancy support to Borutus, you must do the following:

- Generate the migration which will add `tenant_id` to the borutus accounts table

```sh
bundle exec rails g borutus:tenancy
```

- Run the migration

```sh
rake db:migrate
```

- Add an initializer to your Rails application, i.e. `config/initializers/borutus.rb`

```ruby
Borutus.config do |config|
  config.enable_tenancy = true
  config.tenant_class = 'Tenant'
end
```

*NOTE: When building entries, be sure to specify the account directly, rather than use the `account_name` feature. Otherwise you'll probably end up with the wrong account.*


```ruby
debit_account = Borutus::Account.where(:name => "Cash", :tenant => my_tenant).last
credit_account = Borutus::Account.where(:name => "Unearned Revenue", :tenant => my_tenant).last
entry = Borutus::Entry.new(
                :description => "Order placed for widgets",
                :date => Date.yesterday,
                :debits => [
                  {:account => debit_account, :amount => 100.00}],
                :credits => [
                  {:account => credit_account, :amount => 100.00}])
```

Reporting Views
===============

The Engine provides controllers and views for rendering basic reports, including a Balance Sheet and Income Statement.

These views and controllers are read-only for reporting purposes. It is assumed entry creation will occur within your applications code.

Routing is supplied via an engine mount point. Borutus can be mounted on a subpath in your existing Rails 3 app by adding the following to your routes.rb:

```ruby
mount Borutus::Engine => "/borutus", :as => "borutus"
```

*NOTE: The `Borutus::ApplicationController` does not currently support authentication. If you enable routing, the views will be publicly available on your mount point. Authentication can be added by overriding the controller.*

*Future versions of borutus will allow for customization of authentication.*

Testing
=======

[Rspec](http://rspec.info/) tests are provided. Run `bundle install` then `rake`.

Contributing and Contributors
=============================

There's a guide to contributing to Borutus (both code and general help) over in [CONTRIBUTING](https://github.com/bloom-solutions/borutus/blob/master/CONTRIBUTING.md)

Many thanks to all our contributors! Check them all at:

https://github.com/bloom-solutions/borutus/graphs/contributors


Reference
=========

For a complete reference on Accounting principles, we recommend the following textbook

[http://amzn.com/0324662963](http://amzn.com/0324662963)

