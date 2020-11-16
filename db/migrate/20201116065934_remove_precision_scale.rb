class RemovePrecisionScale < ActiveRecord::Migration[5.1]
  def up
    change_column :borutus_amounts, :amount, :decimal
  end

  def down
    change_column :borutus_amounts, :amount, :decimal, precision: 20, scale: 10
  end
end
