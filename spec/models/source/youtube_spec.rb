require 'rails_helper'

RSpec.describe Source::Youtube, type: :model do

    describe 'synchronizer' do

      it 'should return appropriate synchronizer' do
        expect(Source::Youtube.new.synchronizer.class.to_s).to eq "Synchronizer::Youtube"
      end

    end

    describe 'type_specific_fields' do

      it 'should return empty array' do
        expect(Source::Youtube.type_specific_fields).to eq []
      end

    end

end
