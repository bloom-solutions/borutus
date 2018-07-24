# lib/generators/borutus/borutus_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Borutus
  class TenancyGenerator < BaseGenerator
    def create_migration_file
      migration_template 'tenant_migration.rb', 'db/migrate/tenant_borutus_tables.rb'
    end
  end
end
