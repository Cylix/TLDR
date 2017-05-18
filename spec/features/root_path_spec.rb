require 'rails_helper'

RSpec.feature "RootPath", type: :feature do

  let(:user) { create(:user) }

  describe 'home' do

    context 'not authenticated' do

      it 'should work' do
        visit root_path
        expect(page.status_code).to be 200
      end

      it 'should render unauthenticated home page' do
        visit root_path

        expect(page).to have_link 'Log in'
        expect(page).to have_link 'Sign up'

        expect(page).not_to have_link 'Sign out'
        expect(page).not_to have_text user.to_s
      end

    end

    context 'authenticated' do

      before(:each) { login_as user, scope: :user }

      it 'should work' do
        visit root_path
        expect(page.status_code).to be 200
      end

      it 'should render authenticated dashboard' do
        visit root_path

        expect(page).not_to have_link 'Log in'
        expect(page).not_to have_link 'Sign up'

        expect(page).to have_link 'Sign out'
        expect(page).to have_text user.to_s
      end

      it 'should redirect to contents page' do
        visit root_path
        expect(current_path).to eq filter_contents_path(:inbox)
      end

    end

  end

end
