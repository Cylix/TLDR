require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:user) { create(:user) }
  let(:category) { build(:category, user: user) }

  it 'expects category factory to be valid' do
    expect(category.valid?).to be_truthy
  end

  describe 'ordering' do

    let(:category_1) { create(:category, name: "cba", user: user) }
    let(:category_2) { create(:category, name: "abc", user: user) }

    it 'should order by name ASC' do
      expect(Category.all).to eq [category_2, category_1]
    end

  end

  describe 'validations' do

    describe 'name' do

      describe 'uniqueness' do

        context 'same user' do

          let!(:category_1) { create(:category, name: "abc", user: user) }
          let!(:category_2) { build(:category, name: "abc", user: user) }

          it 'cant have two categories with same name' do
            expect(category_2.valid?).to be_falsey
          end

        end

        context 'different users' do

          let(:other_user) { create(:user_edited) }

          let!(:category_1) { create(:category, name: "abc", user: user) }
          let!(:category_2) { build(:category, name: "abc", user: other_user) }

          it 'cant have two categories with same name' do
            expect(category_2.valid?).to be_truthy
          end

        end

      end

      describe 'presence' do

        it "can't be empty" do
          category.name = ""
          expect(category.valid?).to be_falsey
        end

        it "can't be nil" do
          category.name = nil
          expect(category.valid?).to be_falsey
        end

        it "can't be blank" do
          category.name = "         "
          expect(category.valid?).to be_falsey
        end

      end

    end

    describe 'user' do

      describe 'associated' do

        it "can't have an invalid association" do
          category.user_id += 1
          expect(category.valid?).to be_falsey
        end

      end

      describe 'presence' do

        it "can't have no associated user" do
          category.user = nil
          expect(category.valid?).to be_falsey
        end

        it "can't have no associated user id" do
          category.user_id = nil
          expect(category.valid?).to be_falsey
        end

      end

    end

  end

end
