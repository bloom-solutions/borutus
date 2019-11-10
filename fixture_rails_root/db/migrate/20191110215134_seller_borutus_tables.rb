class SellerBorutusTables < ActiveRecord::Migration[4.2]
  def change
    # add a seller column to borutus accounts table.
    add_column :borutus_accounts, :seller_id, :integer, index: true
  end
end
