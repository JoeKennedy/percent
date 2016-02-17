module Percent
  module ActiveRecord
    module Percentizable
      extend ActiveSupport::Concern

      module ClassMethods
        def percentize(*columns)
          # initialize options
          options = columns.extract_options!
          options[:hide_percent_sign] = options.fetch :hide_percent_sign, true

          columns.each do |column|
            column_name = column.to_s
            field_name = column_name.sub /_fraction$/, ""

            # validation
            unless options[:disable_validation]
              allow_nil = options.fetch :allow_nil, false
              numericality = options[:numericality]
              fraction = options[:fraction_numericality]

              if numericality || !options.key?(:numericality)
                numericality = numericality_range 0, 100 unless fraction.is_a? Hash

                validates field_name, {
                  allow_nil: allow_nil,
                  'percent/active_model/percentage': numericality
                }
              end

              if fraction || !options.key?(:fraction_numericality)
                unless numericality.is_a?(Hash) && options.key?(:numericality)
                  fraction = numericality_range 0, 1
                end

                validates column_name, allow_nil: allow_nil, numericality: fraction
              end
            end

            # percent attribute getter
            define_method field_name do
              value = public_send column_name
              value.nil? ? value : Percentage.from_fraction(value, options)
            end

            # percent attribute setter
            define_method "#{field_name}=" do |value|
              unless value.nil? || value.is_a?(Percentage)
                value = Percentage.from_amount value, options
              end
              public_send "#{column_name}=", (value.nil? ? value : value.to_d)
            end
          end
        end

      private 

        def numericality_range(min, max)
          { greater_than_or_equal_to: min, less_than_or_equal_to: max }
        end
      end
    end
  end
end
