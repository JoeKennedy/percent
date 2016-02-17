module Percent
  module ActiveRecord
    module MigrationExtensions
      module Table
        def percentage(accessor, options={})
          *opts = Options.without_table accessor, options
          column *opts
        end

        def remove_percentage(accessor, options={})
          *opts = Options.without_table accessor, options
          remove *opts
        end
      end
    end
  end
end

