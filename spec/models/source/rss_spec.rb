require 'rails_helper'

RSpec.describe Source::RSS, type: :model do

    describe 'synchronizer' do

      it 'should return appropriate synchronizer' do
        expect(Source::RSS.new.synchronizer.class.to_s).to eq "Synchronizer::RSS"
      end

    end

    describe 'type_specific_fields' do

      it 'should return empty array' do
        expect(Source::RSS.type_specific_fields).to eq %w[rss_feed]
      end

    end

end
