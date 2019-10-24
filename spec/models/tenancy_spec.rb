require 'spec_helper'

module Borutus
  describe Account do
    describe 'tenancy support' do
      before(:each) do
        ActiveSupportHelpers.clear_model('Account')
        ActiveSupportHelpers.clear_model('Asset')

        Borutus.enable_tenancy = true
        Borutus.tenant_class = 'Borutus::Entry'

        FactoryBotHelpers.reload()
        Borutus::Asset.new
      end

      after(:each) do
        if Borutus.const_defined?(:Asset)
          ActiveSupportHelpers.clear_model('Account')
          ActiveSupportHelpers.clear_model('Asset')
        end

        Borutus.enable_tenancy = false
        Borutus.tenant_class = nil

        FactoryBotHelpers.reload()
      end

      it 'validate uniqueness of name scoped to tenant' do
        account = FactoryBot.create(:asset, tenant_id: 10)

        record = FactoryBot.build(:asset, name: account.name, tenant_id: 10)
        expect(record).not_to be_valid
        expect(record.errors[:name]).to eq(['has already been taken'])
      end

      it 'allows same name scoped under a different tenant' do
        account = FactoryBot.create(:asset, tenant_id: 10)

        record = FactoryBot.build(:asset, name: account.name, tenant_id: 11)
        expect(record).to be_valid
      end
    end
  end
end
