module Percent
  class Hooks
    def self.init
      ActiveSupport.on_load(:active_record) do
        require 'percent/active_model/percentage_validator'
        require 'percent/active_record/percentizable'
        ::ActiveRecord::Base.send :include, Percent::ActiveRecord::Percentizable

        require 'percent/active_record/migration_extensions/options'
        require 'percent/active_record/migration_extensions/schema_statements'
        require 'percent/active_record/migration_extensions/table'
        ::ActiveRecord::Migration.send :include, Percent::ActiveRecord::MigrationExtensions::SchemaStatements
        ::ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Percent::ActiveRecord::MigrationExtensions::Table
        ::ActiveRecord::ConnectionAdapters::Table.send :include, Percent::ActiveRecord::MigrationExtensions::Table
      end
    end
  end
end
