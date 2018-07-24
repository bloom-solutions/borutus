class TenantBorutusTables < ActiveRecord::Migration[4.2]
  def change
    # add a tenant column to borutus accounts table.
    add_column :borutus_accounts, :tenant_id, :integer, index: true
  end
end
