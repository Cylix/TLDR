require 'rails_helper'

RSpec.describe Source::Facebook, type: :model do

    describe 'synchronizer' do

      it 'should return appropriate synchronizer' do
        expect(Source::Facebook.new.synchronizer.class.to_s).to eq "Synchronizer::Facebook"
      end

    end

    describe 'type_specific_fields' do

      it 'should return empty array' do
        expect(Source::Facebook.type_specific_fields).to eq []
      end

    end

end
