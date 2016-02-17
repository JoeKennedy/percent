module Percent
  module ActiveRecord
    module MigrationExtensions
      module Options
        def self.without_table(accessor, options = {})
          column_name = accessor.to_s + '_fraction'
          options[:null] ||= false
          options[:default] ||= 0
          type = :decimal

          [column_name, type, options]
        end

        def self.with_table(table_name, accessor, options = {})
          options = self.without_table accessor, options
          options.unshift table_name
        end
      end
    end
  end
end
