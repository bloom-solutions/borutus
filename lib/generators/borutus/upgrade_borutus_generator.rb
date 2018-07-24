# lib/generators/borutus/borutus_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Borutus
  class UpgradeBorutusGenerator < BaseGenerator
    def create_migration_file
      migration_template 'update_migration.rb', 'db/migrate/update_borutus_tables.rb'
    end
  end
end
