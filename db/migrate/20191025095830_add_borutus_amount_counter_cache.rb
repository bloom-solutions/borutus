class AddBorutusAmountCounterCache < ActiveRecord::Migration[4.2]

  def up
    add_column :borutus_accounts, :borutus_amounts_count, :integer

    Borutus::Account.all.pluck(:id).each do |id|
      Borutus::Account.reset_counters(id, :debit_amounts)
      Borutus::Account.reset_counters(id, :credit_amounts)
    end
  end

  def down
    remove_column :borutus_accounts, :borutus_amounts_count
  end

end
