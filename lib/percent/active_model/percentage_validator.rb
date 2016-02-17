module Percent
  module ActiveModel
    class PercentageValidator < ::ActiveModel::Validations::NumericalityValidator
      def validate_each(record, attr, value)
        super record, attr, (value.nil? ? value : value.to_decimal)
      end
    end
  end
end

ActiveModel::Validations::PercentageValidator = Percent::ActiveModel::PercentageValidator
