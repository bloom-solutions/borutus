# This migration comes from borutus (originally 20191025154652)
class ChangeBorutusAmountCountColumn < ActiveRecord::Migration[4.2]

  def up
    remove_column :borutus_accounts, :borutus_amounts_count
    add_column :borutus_accounts, :amounts_count, :integer

    Borutus::Account.all.pluck(:id).each do |id|
      Borutus::Account.reset_counters(id, :amounts)
    end
  end

  def down
    remove_column :borutus_accounts, :amounts_count
  end

end
