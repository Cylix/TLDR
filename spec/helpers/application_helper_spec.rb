require 'rails_helper'

include ApplicationHelper

$_resource = nil
def resource
  $_resource
end

RSpec.feature "ApplicationHelper", type: :feature do

  describe 'has_model_error?' do

    let(:user) { build(:user) }

    context 'with no error' do

      it 'should return false' do
        $_resource = user
        expect(user.valid?).to be_truthy
        expect(ApplicationHelper::has_model_error?).to be_falsey
      end

    end

    context 'with some errors' do

      it 'should return true' do
        $_resource = user
        user.email = nil
        expect(user.valid?).to be_falsey
        expect(ApplicationHelper::has_model_error?).to be_truthy
      end

    end

  end

  describe 'model_errors' do

    let(:user) { build(:user) }

    it 'should return the model errors' do
      $_resource = user
      user.email = nil
      expect(user.valid?).to be_falsey
      expect(ApplicationHelper::model_errors).to eq ["Email can't be blank", "Email is invalid"]
    end

  end

  describe 'navbar_active_link' do

    describe 'with match' do

      context 'with sym & sym' do

        it 'should return active' do
          expect(ApplicationHelper::navbar_active_link({page_type: :contents, extra: :inbox}.to_json, :contents, :inbox)).to eq 'active'
        end

      end

      context 'with sym & string' do

        it 'should return active' do
          expect(ApplicationHelper::navbar_active_link({page_type: :contents, extra: :inbox}.to_json, "contents", "inbox")).to eq 'active'
        end

      end

      context 'with string & sym' do

        it 'should return active' do
          expect(ApplicationHelper::navbar_active_link({"page_type" => "contents", "extra" => "inbox"}.to_json, :contents, :inbox)).to eq 'active'
        end

      end

      context 'with int & int' do

        it 'should return active' do
          expect(ApplicationHelper::navbar_active_link({page_type: :contents, extra: 1}.to_json, :contents, 1)).to eq 'active'
        end

      end

      context 'with int & string' do

        it 'should return active' do
          expect(ApplicationHelper::navbar_active_link({page_type: :contents, extra: 1}.to_json, :contents, "1")).to eq 'active'
        end

      end

      context 'with nil extra' do

        it 'should return active' do
          expect(ApplicationHelper::navbar_active_link({page_type: :contents}.to_json, :contents)).to eq 'active'
        end

      end

    end

    describe 'with different type' do

      it 'should return nil' do
        expect(ApplicationHelper::navbar_active_link({page_type: :contents, extra: :inbox}.to_json, :contents_different, :inbox)).to eq nil
      end

    end

    describe 'with different extra' do

      it 'should return nil' do
        expect(ApplicationHelper::navbar_active_link({page_type: :contents, extra: :inbox}.to_json, :contents, :inbox_different)).to eq nil
      end


    end

    describe 'with exception' do

      it 'should return nil' do
        expect(ApplicationHelper::navbar_active_link("lol", :contents, :inbox_different)).to eq nil
      end

    end

  end

  describe 'trunk_words' do

    context 'with right number of words' do

      it 'should not trunk' do
        expect(ApplicationHelper::trunk_words "hello how are you?", 4).to eq "hello how are you?"
      end

    end

    context 'with too many words' do

      it 'should trunk' do
        expect(ApplicationHelper::trunk_words "hello how are you?", 2).to eq "hello how..."
      end

    end

  end

end
