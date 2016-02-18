require 'spec_helper'

class Survey < ActiveRecord::Base
  percentize :percent_complete_fraction
  percentize :non_fraction_ending
  percentize :as_option_percent_fraction,    as: :percent
  percentize :optional_fraction,             allow_nil: true
  percentize :sans_validation_fraction,      disable_validation: true
  percentize :sans_frac_validate_fraction,   fraction_numericality: false
  percentize :in_a_weird_range_fraction,     allow_nil: true,
              numericality: { greater_than: -10, less_than: 200 }
  percentize :in_fraction_range_fraction,    allow_nil: true,
              fraction_numericality: { greater_than: -0.1, less_than: 2.0 }
  percentize :first_percent_fraction, :second_percent_fraction, allow_nil: true
end

class InheritedPercentizeSurvey < Survey
end
