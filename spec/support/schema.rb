ActiveRecord::Schema.define do
  self.verbose = false

  create_table :surveys, force: true do |t|
    t.decimal :percent_complete_fraction
    t.decimal :non_fraction_ending
    t.decimal :as_option_percent_fraction
    t.decimal :optional_fraction
    t.decimal :sans_validation_fraction
    t.decimal :sans_frac_validate_fraction
    t.decimal :in_a_weird_range_fraction
    t.decimal :in_fraction_range_fraction
    t.decimal :first_percent_fraction
    t.decimal :second_percent_fraction
    t.timestamps null: false
  end
end
