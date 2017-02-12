require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user) }

  it 'expects user factory to be valid' do
    expect(user.valid?).to be_truthy
  end

  describe 'validations' do

    describe 'first_name' do

      describe 'presence' do

        it "can't be empty" do
          user.first_name = ""
          expect(user.valid?).to be_falsey
        end

        it "can't be nil" do
          user.first_name = nil
          expect(user.valid?).to be_falsey
        end

        it "can't be blank" do
          user.first_name = "         "
          expect(user.valid?).to be_falsey
        end

      end

      describe 'minimum length' do

        it "can't be less than 2 characters" do
          user.first_name = 'a'
          expect(user.valid?).to be_falsey
        end

      end

    end

    describe 'last_name' do

      describe 'presence' do

        it "can't be empty" do
          user.last_name = ""
          expect(user.valid?).to be_falsey
        end

        it "can't be nil" do
          user.last_name = nil
          expect(user.valid?).to be_falsey
        end

        it "can't be blank" do
          user.last_name = "         "
          expect(user.valid?).to be_falsey
        end

      end

      describe 'minimum length' do

        it "can't be less than 2 characters" do
          user.last_name = 'a'
          expect(user.valid?).to be_falsey
        end

      end

    end

    describe 'email' do

      describe 'uniqueness' do

        before { create(:user_edited, email: user.email) }

        it "can't use an existing email" do
          expect(user.valid?).to be_falsey
        end

      end

      describe 'presence' do

        it "can't be empty" do
          user.email = ""
          expect(user.valid?).to be_falsey
        end

        it "can't be nil" do
          user.email = nil
          expect(user.valid?).to be_falsey
        end

        it "can't be blank" do
          user.email = "         "
          expect(user.valid?).to be_falsey
        end

      end

      describe 'format' do

        it "can't have an invalid format" do
          ["mail", "mail@", "mail@example", "mail@example.", "@example.", "example.", ".", "@", "@example", "@example."].each do |email|
            user.email = email
            expect(user.valid?).to be_falsey
          end
        end

      end

    end

    describe 'password' do

      describe 'presence' do

        it "can't be empty" do
          user.password = user.password_confirmation = ""
          expect(user.valid?).to be_falsey
        end

        it "can't be nil" do
          user.password = user.password_confirmation = nil
          expect(user.valid?).to be_falsey
        end

        it "can't be blank" do
          user.password = user.password_confirmation = "         "
          expect(user.valid?).to be_falsey
        end

      end

      describe 'minimum length' do

        it "can't be less than 6 characters" do
          user.password = user.password_confirmation = "a" * 5
          expect(user.valid?).to be_falsey
        end

      end

    end

    describe 'password_confirmation' do

      describe 'match password' do

        it 'must match password' do
          user.password_confirmation = user.password * 2
          expect(user.valid?).to be_falsey
        end

      end

    end

  end

  describe 'methods' do

    describe 'to_s' do

      it 'should return the expected format' do
        user.first_name = 'JOHN'
        user.last_name = 'DOE'
        expect(user.to_s).to eq 'John Doe'
      end

    end

  end

  describe 'associations' do

    describe 'sources' do

      describe 'dependent destroy' do

        let!(:source) { create(:rss_source, user: user) }

        it "should destroy the user sources when user is destroy" do
          expect(Source.count).to eq 1
          user.destroy!
          expect(Source.count).to eq 0
        end

      end

    end

  end

end
