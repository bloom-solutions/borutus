# lib/generators/borutus/borutus_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Borutus
  class MarketplaceGenerator < BaseGenerator
    def create_migration_file
      migration_template 'seller_migration.rb', 
                         'db/migrate/seller_borutus_tables.rb'
    end
  end
end
