# This migration comes from borutus (originally 20191025095830)
class AddBorutusAmountCounterCache < ActiveRecord::Migration[4.2]

  def up
    add_column :borutus_accounts, :borutus_amounts_count, :integer

    Borutus::Account.all.pluck(:id).each do |id|
      Borutus::Account.reset_counters(id, :borutus_amounts)
    end
  end

  def down
    remove_column :borutus_accounts, :borutus_amounts_count
  end

end
