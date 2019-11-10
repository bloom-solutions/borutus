# Borutus
require "rails"
require "light-service"

module Borutus
  # ------------------------------ tenancy ------------------------------
  # configuration to enable or disable tenancy
  mattr_accessor :enable_tenancy
  enable_tenancy = false

  mattr_accessor :tenant_class
  tenant_class = nil

  # ------------------------------ marketplace ------------------------------
  # configuration to enable or disable marketplace
  mattr_accessor :enable_marketplace
  enable_marketplace = false

  mattr_accessor :seller_class
  seller_class = nil

  # provide hook to configure attributes
  def self.config
    yield(self)
  end
end

require "borutus/engine"
