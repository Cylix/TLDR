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

        expect(page).to have_link 'Sign In'
        expect(page).to have_link 'Sign Up'

        expect(page).not_to have_link 'Sign Out'
        expect(page).not_to have_text user.to_s
      end

    end

    context 'authenticated' do

      before :each { login_as user, scope: :user }

      it 'should work' do
        visit root_path
        expect(page.status_code).to be 200
      end

      it 'should render authenticated dashboard' do
        visit root_path

        expect(page).not_to have_link 'Sign In'
        expect(page).not_to have_link 'Sign Up'

        expect(page).to have_link 'Sign Out'
        expect(page).to have_text user.to_s
      end

    end

  end

end
