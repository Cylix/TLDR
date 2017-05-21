require 'rails_helper'

RSpec.describe Source::Twitter, type: :model do

    describe 'synchronizer' do

      it 'should return appropriate synchronizer' do
        expect(Source::Twitter.new.synchronizer.class.to_s).to eq "Synchronizer::Twitter"
      end

    end

    describe 'type_specific_fields' do

      it 'should return empty array' do
        expect(Source::Twitter.type_specific_fields).to eq []
      end

    end

end
