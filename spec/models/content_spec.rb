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

  describe 'utility functions' do

    describe 'is_done?' do

      it 'should return true if the category is done' do
        content.category = :done
        expect(content.is_done?).to be_truthy
      end

      it 'should return false if the category is trash' do
        content.category = :trashed
        expect(content.is_done?).to be_falsey
      end

      it 'should return false if the category is snooze' do
        content.category = :snoozed
        expect(content.is_done?).to be_falsey
      end

    end

    describe 'is_snoozed?' do

      it 'should return false if the category is done' do
        content.category = :done
        expect(content.is_snoozed?).to be_falsey
      end

      it 'should return false if the category is trash' do
        content.category = :trashed
        expect(content.is_snoozed?).to be_falsey
      end

      it 'should return true if the category is snooze' do
        content.category = :snoozed
        expect(content.is_snoozed?).to be_truthy
      end

    end

    describe 'is_trashed?' do

      it 'should return false if the category is done' do
        content.category = :done
        expect(content.is_trashed?).to be_falsey
      end

      it 'should return true if the category is trash' do
        content.category = :trashed
        expect(content.is_trashed?).to be_truthy
      end

      it 'should return false if the category is snooze' do
        content.category = :snoozed
        expect(content.is_trashed?).to be_falsey
      end

    end

  end

  describe 'validations' do

    describe 'is_pinned' do

      describe 'inclusion [true, false]' do

        it 'must be a valid boolean value (convert all values to bool)' do
          content.is_pinned = "hello"
          expect(content.valid?).to be_truthy
          expect(content.is_pinned).to eq true
        end

      end

      describe 'presence' do

        it "can't be empty" do
          content.is_pinned = ""
          expect(content.valid?).to be_falsey
        end

        it "can't be nil" do
          content.is_pinned = nil
          expect(content.valid?).to be_falsey
        end

        it "can't be blank (converted to bool)" do
          content.is_pinned = "         "
          expect(content.valid?).to be_truthy
          expect(content.is_pinned).to eq true
        end

      end

    end

    describe 'category' do

      describe 'inclusion [VALID CATEGORIES]' do

        it 'must be a valid category' do
          expect { content.category = "hello" }.to raise_error ArgumentError
        end

      end

      describe 'presence' do

        it "can't be empty" do
          content.category = ""
          expect(content.valid?).to be_falsey
        end

        it "can't be nil" do
          content.category = nil
          expect(content.valid?).to be_falsey
        end

        it "can't be blank" do
          content.category = "         "
          expect(content.valid?).to be_falsey
        end

      end

    end

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
