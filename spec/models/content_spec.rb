require 'rails_helper'

RSpec.describe Content, type: :model do

  let(:content) { build(:content_with_user_with_source) }

  it 'expects content factory to be valid' do
    expect(content.valid?).to be_truthy
  end

  describe 'validations' do

    describe 'title' do

      describe 'presence' do

        it "can't be empty" do
          content.title = ""
          expect(content.valid?).to be_falsey
        end

        it "can't be nil" do
          content.title = nil
          expect(content.valid?).to be_falsey
        end

        it "can't be blank" do
          content.title = "         "
          expect(content.valid?).to be_falsey
        end

      end

    end

    describe 'url' do

      describe 'presence' do

        it "can't be empty" do
          content.url = ""
          expect(content.valid?).to be_falsey
        end

        it "can't be nil" do
          content.url = nil
          expect(content.valid?).to be_falsey
        end

        it "can't be blank" do
          content.url = "         "
          expect(content.valid?).to be_falsey
        end

      end

      describe 'format' do

        it "can't have an invalid format" do
          ["hello", "hello.", "http:", "http:/", "http://", "http:/hello", "http//hello"].each do |url|
            content.url = url
            expect(content.valid?).to be_falsey
          end
        end

      end

    end

    describe 'user' do

      describe 'associated' do

        it "can't have an invalid association" do
          content.user_id += 1
          expect(content.valid?).to be_falsey
        end

      end

      describe 'presence' do

        it "can't have no associated user" do
          content.user = nil
          expect(content.valid?).to be_falsey
        end

        it "can't have no associated user id" do
          content.user_id = nil
          expect(content.valid?).to be_falsey
        end

      end

    end

    describe 'source' do

      describe 'associated' do

        it "can't have an invalid association" do
          content.source_id += 1
          expect(content.valid?).to be_falsey
        end

      end

      describe 'presence' do

        it "can't have no associated source" do
          content.source = nil
          expect(content.valid?).to be_falsey
        end

        it "can't have no associated source id" do
          content.source_id = nil
          expect(content.valid?).to be_falsey
        end

      end

    end

  end

end
