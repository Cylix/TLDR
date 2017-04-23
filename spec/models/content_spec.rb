require 'rails_helper'

RSpec.describe Content, type: :model do

  let!(:content) { build(:content_with_user_with_source) }

  it 'expects content factory to be valid' do
    expect(content.valid?).to be_truthy
  end

  describe 'orders' do

    before { content.save }
    let!(:content_2) { create(:content_edited, user: content.user, source: content.source) }

    it 'should order contents by created_at DESC' do
      expect(Content.all).to eq [content_2, content]
    end

  end

  describe 'validations' do

    describe 'synchronized_at' do

      describe 'presence' do

        it "can't be empty" do
          content.synchronized_at = ""
          expect(content.valid?).to be_falsey
        end

        it "can't be nil" do
          content.synchronized_at = nil
          expect(content.valid?).to be_falsey
        end

        it "can't be blank" do
          content.synchronized_at = "         "
          expect(content.valid?).to be_falsey
        end

        it "must be a date" do
          content.synchronized_at = "blabla"
          expect(content.valid?).to be_falsey
        end

      end

    end

    describe 'published_at' do

      it 'can be nil' do
        content.published_at = nil
        expect(content.valid?).to be_truthy
      end

      it 'can be blank' do
        content.published_at = ''
        expect(content.valid?).to be_truthy
      end

      it 'must be a date' do
        content.published_at = 'blabla'
        expect(content.valid?).to be_truthy
        expect(content.published_at).to be_nil
      end

    end

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
