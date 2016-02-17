require 'spec_helper'

class JobTracker < ActiveRecord::Base; end

if defined? ActiveRecord
  describe Percent::ActiveRecord::MigrationExtensions::SchemaStatements do
    before :all do
      @connection = ActiveRecord::Base.connection
      @connection.send :extend, Percent::ActiveRecord::MigrationExtensions::SchemaStatements

      @connection.drop_table :job_trackers if @connection.table_exists? :job_trackers
      @connection.create_table :job_trackers

      @options = { default: 1, null: true }

      @connection.add_percentage :job_trackers, :percentage
      @connection.add_percentage :job_trackers, :full_options, @options

      JobTracker.reset_column_information
    end

    describe '#add_percentage' do
      context 'default options' do
        subject { JobTracker.columns_hash['percentage_fraction'] }

        it 'should default to 0' do
          expect(subject.default).to eql '0'
          expect(JobTracker.new.public_send subject.name).to eql 0
        end

        it 'should not allow null values' do
          expect(subject.null).to be false
        end

        it 'should be of type decimal' do
          expect(subject.type).to eql :decimal
        end
      end

      context 'full options' do
        subject { JobTracker.columns_hash['full_options_fraction'] }

        it 'should default to 1' do
          expect(subject.default).to eql '1'
          expect(JobTracker.new.public_send subject.name).to eql 1
        end

        it 'should allow null values' do
          expect(subject.null).to be true
        end

        it 'should be of type decimal' do
          expect(subject.type).to eql :decimal
        end
      end
    end

    describe '#remove_percentage' do
      before :all do
        @connection.remove_percentage :job_trackers, :percentage
        @connection.remove_percentage :job_trackers, :full_options, @options

        JobTracker.reset_column_information
      end

      it 'should remove percentage columns' do
        expect(JobTracker.columns_hash['percentage_fraction']).to be nil
        expect(JobTracker.columns_hash['full_options_fraction']).to be nil
      end
    end

  end
end
