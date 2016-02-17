require 'spec_helper'

if defined? ActiveRecord
  describe Percent::ActiveRecord::Percentizable do
    describe '#percentize' do
      shared_examples_for 'Survey methods' do
        it { is_expected.to respond_to(:percent_complete) }
        it { is_expected.to respond_to(:percent_complete=) }
        it { is_expected.to respond_to(:without_percent_sign) }
        it { is_expected.to respond_to(:without_percent_sign=) }
        it { is_expected.to respond_to(:with_percent_sign) }
        it { is_expected.to respond_to(:with_percent_sign=) }
        it { is_expected.to respond_to(:optional) }
        it { is_expected.to respond_to(:optional=) }
        it { is_expected.to respond_to(:sans_validation) }
        it { is_expected.to respond_to(:sans_validation=) }
        it { is_expected.to respond_to(:sans_frac_validate) }
        it { is_expected.to respond_to(:sans_frac_validate=) }
        it { is_expected.to respond_to(:in_a_weird_range) }
        it { is_expected.to respond_to(:in_a_weird_range=) }
        it { is_expected.to respond_to(:in_fraction_range) }
        it { is_expected.to respond_to(:in_fraction_range=) }
        it { is_expected.to respond_to(:first_percent) }
        it { is_expected.to respond_to(:first_percent=) }
        it { is_expected.to respond_to(:second_percent) }
        it { is_expected.to respond_to(:second_percent=) }
      end

      let (:subject) do
        Survey.create percent_complete_fraction: 0.1,
                      without_percent_sign_fraction: 0.2,
                      with_percent_sign_fraction: 0.3,
                      optional_fraction: 0.4,
                      sans_validation_fraction: 0.5,
                      sans_frac_validate_fraction: 0.6,
                      in_a_weird_range_fraction: 0.7,
                      in_fraction_range_fraction: 0.8,
                      first_percent_fraction: 0.9,
                      second_percent_fraction: 1.0
      end

      describe 'methods' do
        it_should_behave_like 'Survey methods'
      end

      context 'inherited class instance' do
        let (:subject) { InheritedPercentizeSurvey.new }
        it_should_behave_like 'Survey methods'
      end

      describe 'percentized attribute getter' do
        it 'attaches a Percentage object to model field' do
          expect(subject.percent_complete).to be_an_instance_of Percentage
          expect(subject.without_percent_sign).to be_an_instance_of Percentage
          expect(subject.with_percent_sign).to be_an_instance_of Percentage
          expect(subject.optional).to be_an_instance_of Percentage
          expect(subject.sans_validation).to be_an_instance_of Percentage
          expect(subject.sans_frac_validate).to be_an_instance_of Percentage
          expect(subject.in_a_weird_range).to be_an_instance_of Percentage
          expect(subject.in_fraction_range).to be_an_instance_of Percentage
        end

        it 'attaches a Percentage object to multiple model fields' do
          expect(subject.first_percent).to be_an_instance_of Percentage
          expect(subject.second_percent).to be_an_instance_of Percentage
        end

        it 'returns the expected percentage amount as a Percentage object' do
          expect(subject.percent_complete).to eql Percentage.new(10)
          expect(subject.without_percent_sign).to eql Percentage.new(20)
          expect(subject.with_percent_sign).to eql Percentage.new(30)
          expect(subject.optional).to eql Percentage.new(40)
          expect(subject.sans_validation).to eql Percentage.new(50)
          expect(subject.sans_frac_validate).to eql Percentage.new(60)
          expect(subject.in_a_weird_range).to eql Percentage.new(70)
          expect(subject.in_fraction_range).to eql Percentage.new(80)
          expect(subject.first_percent).to eql Percentage.new(90)
          expect(subject.second_percent).to eql Percentage.new(100)
        end
      end

      describe 'percentized attribute setter' do
        context 'assign value to percentized attribute' do
          it 'assigns the correct value from a Percentage object' do
            subject.percent_complete = Percentage.new(0)
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new(0)
          end

          it 'assigns the correct value from an integer' do
            subject.percent_complete = 10
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.1')
          end

          it 'assigns the correct value from a complex number' do
            subject.percent_complete = Complex(20,0)
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.2')
          end

          it 'assigns the correct value from a decimal' do
            subject.percent_complete = BigDecimal.new(30)
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.3')
          end

          it 'assigns the correct value from a float' do
            subject.percent_complete = 40.0
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.4')
          end

          it 'assigns the correct value from a rational number' do
            subject.percent_complete = Rational(100,2)
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.5')
          end

          it 'assigns the correct value from a string with value "60"' do
            subject.percent_complete = '60'
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.6')
          end

          it 'assigns the correct value from a string with value "70.0"' do
            subject.percent_complete = '70.0'
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.7')
          end

          it 'assigns the correct value from a string with value "0.8E2"' do
            subject.percent_complete = '0.8E2'
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.8')
          end

          it 'assigns the correct value from a string with value "810/9"' do
            subject.percent_complete = '810/9'
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.9')
          end

          it 'assigns the correct value from a string with value "100%"' do
            subject.percent_complete = '100%'
            expect(subject.save).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new(1)
          end
        end

        context 'assign value to percentized attribute on create' do
          it 'assigns the correct value from a Percentage object' do
            subject = Survey.create percent_complete: 15.0,
                                    without_percent_sign: 0,
                                    with_percent_sign: 0,
                                    sans_frac_validate: 0
            expect(subject.valid?).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.15')
          end

          it 'assigns the correct value from a number' do
            subject = Survey.create percent_complete: 35.0,
                                    without_percent_sign: 0,
                                    with_percent_sign: 0,
                                    sans_frac_validate: 0
            expect(subject.valid?).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.35')
          end

          it 'assigns the correct value from a string' do
            subject = Survey.create percent_complete: '55',
                                    without_percent_sign: 0,
                                    with_percent_sign: 0,
                                    sans_frac_validate: 0
            expect(subject.valid?).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.55')
          end
        end

        context 'assign value to percentized attribute on update' do
          it 'assigns the correct value from a Percentage object' do
            expect(subject.update_attributes percent_complete: Percentage.new(25)).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.25')
          end

          it 'assigns the correct value from a number' do
            expect(subject.update_attributes percent_complete: 45.0).to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.45')
          end

          it 'assigns the correct value from a string' do
            expect(subject.update_attributes percent_complete: '65').to be_truthy
            expect(subject.percent_complete_fraction).to eql BigDecimal.new('0.65')
          end
        end
      end

      describe 'numericality validation' do
        context 'when no validation options are passed' do
          it 'ensures that the percentage can not be nil' do
            subject.percent_complete = nil
            expect(subject).to_not be_valid
          end

          it 'ensures that the percentage is between 0 and 100' do
            subject.percent_complete = true
            expect(subject).to be_valid

            subject.percent_complete = false
            expect(subject).to be_valid

            subject.percent_complete = -1
            expect(subject).to_not be_valid

            subject.percent_complete = 101
            expect(subject).to_not be_valid

            subject.percent_complete = 10
            expect(subject).to be_valid
          end
        end

        context 'when validation options are passed' do
          it 'ensures that the percentage matches the given criteria' do
            subject.in_a_weird_range = -10
            expect(subject).to_not be_valid

            subject.in_a_weird_range = 0
            expect(subject).to be_valid

            subject.in_a_weird_range = true
            expect(subject).to be_valid

            subject.in_a_weird_range = false
            expect(subject).to be_valid

            subject.in_a_weird_range = 200
            expect(subject).to_not be_valid

            subject.in_a_weird_range = 100
            expect(subject).to be_valid
          end
        end

        context 'when false is passed' do
          it 'should not validate any values passed to the attribute' do
            subject.sans_frac_validate_fraction = 'string'
            expect(subject).to be_valid

            subject.sans_frac_validate_fraction = false
            expect(subject).to be_valid

            subject.sans_frac_validate_fraction = true
            expect(subject).to be_valid
          end
        end
      end

      describe 'fraction numericality validation' do
        context 'when no validation options are passed' do
          it 'ensures that the percentage fraction can not be nil' do
            subject.percent_complete_fraction = nil
            expect(subject).to_not be_valid
          end

          it 'ensures that the percentage fraction is between 0 and 1' do
            subject.percent_complete_fraction = -0.01
            expect(subject).to_not be_valid

            subject.percent_complete_fraction = 1.01
            expect(subject).to_not be_valid

            subject.percent_complete_fraction = 0.1
            expect(subject).to be_valid
          end
        end

        context 'when validation options are passed' do
          it 'ensures that the percentage matches the given criteria' do
            subject.in_fraction_range_fraction = -0.1
            expect(subject).to_not be_valid

            subject.in_fraction_range_fraction = 0
            expect(subject).to be_valid

            subject.in_fraction_range_fraction = 2
            expect(subject).to_not be_valid

            subject.in_fraction_range_fraction = 1
            expect(subject).to be_valid
          end
        end
      end

      describe 'allow nil validation' do
        context 'when no validation is passed' do
          it 'ensures that the percentage and percentage fraction can not be nil' do
            subject.percent_complete_fraction = nil
            expect(subject).to_not be_valid
            subject.percent_complete = nil
            expect(subject).to_not be_valid
          end
        end

        context 'when false is passed' do
          it 'ensures that the percentage and percentage fraction can not be nil' do
            subject.percent_complete_fraction = nil
            expect(subject).to_not be_valid
            subject.percent_complete = nil
            expect(subject).to_not be_valid
          end
        end

        context 'when true is passed' do
          it 'allows the percentage and percentage fraction to be nil' do
            subject.optional_fraction = nil
            expect(subject).to be_valid
            subject.optional = nil
            expect(subject).to be_valid
          end
        end
      end

      describe 'disable validation' do
        context 'when disable validation is given a true value' do
          it 'should allow any value' do
            subject.sans_validation = nil
            expect(subject).to be_valid

            subject.sans_validation = 'string'
            expect(subject).to be_valid

            subject.sans_validation_fraction = nil
            expect(subject).to be_valid

            subject.sans_validation_fraction = 'string'
            expect(subject).to be_valid

            subject.sans_validation_fraction = false
            expect(subject).to be_valid

            subject.sans_validation_fraction = true
            expect(subject).to be_valid
          end
        end
      end

    end
  end
end
