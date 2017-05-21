require 'rails_helper'

RSpec.describe Source, type: :model do

  let(:source) { build(:rss_source_with_user) }

  it 'expects source factory to be valid' do
    expect(source.valid?).to be_truthy
  end

  describe 'validations' do

    describe 'synchronization_state' do

      describe 'included in' do

        it 'should be one of the allowed valued' do
          expect{ source.synchronization_state = "abc" }.to raise_error ArgumentError
        end

      end

    end

    describe 'last_synchronized_at' do

      it 'can be nil' do
        source.last_synchronized_at = nil
        expect(source.valid?).to be_truthy
      end

      it 'can be blank' do
        source.last_synchronized_at = ''
        expect(source.valid?).to be_truthy
      end

      it 'must be a date' do
        source.last_synchronized_at = 'blabla'
        expect(source.valid?).to be_truthy
        expect(source.last_synchronized_at).to be_nil
      end

    end

    describe 'name' do

      describe 'presence' do

        it "can't be empty" do
          source.name = ""
          expect(source.valid?).to be_falsey
        end

        it "can't be nil" do
          source.name = nil
          expect(source.valid?).to be_falsey
        end

        it "can't be blank" do
          source.name = "         "
          expect(source.valid?).to be_falsey
        end

      end

      describe 'minimum length' do

        it "can't be less than 2 characters" do
          source.name = 'a'
          expect(source.valid?).to be_falsey
        end

      end

    end

    describe 'description' do

      it 'can be blank' do
        source.description = ""
        expect(source.valid?).to be_truthy
      end

      it "can't be nil" do
        source.description = nil
        expect(source.valid?).to be_falsey
      end

    end

    describe 'type' do

      describe 'presence' do

        it "can't be empty" do
          source.type = ""
          expect(source.valid?).to be_falsey
        end

        it "can't be nil" do
          source.type = nil
          expect(source.valid?).to be_falsey
        end

      end

      describe 'included' do

        it "can't be an invalid value" do
          source.type = 'hello'
          expect(source.valid?).to be_falsey
        end

      end

    end

    describe 'url' do

      describe 'presence' do

        it "can't be empty" do
          source.url = ""
          expect(source.valid?).to be_falsey
        end

        it "can't be nil" do
          source.url = nil
          expect(source.valid?).to be_falsey
        end

        it "can't be blank" do
          source.url = "         "
          expect(source.valid?).to be_falsey
        end

      end

      describe 'format' do

        it "can't have an invalid format" do
          ["hello", "hello.", "http:", "http:/", "http://", "http:/hello", "http//hello"].each do |url|
            source.url = url
            expect(source.valid?).to be_falsey
          end
        end

      end

    end

    describe 'rss_feed' do

      describe 'presence' do

        it "can't be empty" do
          source.rss_feed = ""
          expect(source.valid?).to be_falsey
        end

        it "can't be nil" do
          source.rss_feed = nil
          expect(source.valid?).to be_falsey
        end

        it "can't be blank" do
          source.rss_feed = "         "
          expect(source.valid?).to be_falsey
        end

      end

      describe 'format' do

        it "can't have an invalid format" do
          ["hello", "hello.", "http:", "http:/", "http://", "http:/hello", "http//hello"].each do |rss_feed|
            source.rss_feed = rss_feed
            expect(source.valid?).to be_falsey
          end
        end

      end

    end

    describe 'user' do

      describe 'associated' do

        it "can't have an invalid association" do
          source.user_id += 1
          expect(source.valid?).to be_falsey
        end

      end

      describe 'presence' do

        it "can't have no associated user" do
          source.user = nil
          expect(source.valid?).to be_falsey
        end

        it "can't have no associated user id" do
          source.user_id = nil
          expect(source.valid?).to be_falsey
        end

      end

    end

  end

  describe 'synchronizer' do

    it 'should raise an exception' do
      expect{ Source.new.synchronizer }.to raise_error "No synchronizer defined for source type 'Source'"
    end

  end

  describe 'type_specific_fields' do

    it 'should return empty array' do
      expect(Source.type_specific_fields).to eq []
    end

  end

end
