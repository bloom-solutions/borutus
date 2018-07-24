# lib/generators/borutus/borutus_generator.rb
require 'rails/generators'
require 'rails/generators/migration'
require_relative 'base_generator'

module Borutus
  class BorutusGenerator < BaseGenerator
    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/create_borutus_tables.rb'
    end
  end
end
