module Borutus
  module Marketplace
    extend ActiveSupport::Concern

    included do
      validates :name,
                presence: true,
                uniqueness: { scope: [:seller_id, :tenant_id] }

      if ActiveRecord::VERSION::MAJOR > 4
        belongs_to :seller, class_name: Borutus.seller_class, optional: true
        belongs_to :tenant, class_name: Borutus.tenant_class, optional: true
      else
        belongs_to :seller, class_name: Borutus.seller_class
        belongs_to :tenant, class_name: Borutus.tenant_class
      end
    end
  end
end
