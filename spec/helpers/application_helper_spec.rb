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
