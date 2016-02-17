module Percent
  module ActiveRecord
    module MigrationExtensions
      module SchemaStatements
        def add_percentage(table_name, accessor, options={})
          *opts = Options.with_table table_name, accessor, options
          add_column *opts
        end

        def remove_percentage(table_name, accessor, options={})
          *opts = Options.with_table table_name, accessor, options
          remove_column *opts
        end
      end
    end
  end
end

