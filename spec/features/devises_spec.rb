require 'rails_helper'

RSpec.feature "Devises", type: :feature do

  describe 'sign up' do

    context 'valid submission' do

      let(:user) { build(:user) }

      before :each do
        visit new_user_registration_path

        fill_in "First name",            with: user.first_name
        fill_in "Last name",             with: user.last_name
        fill_in "Email",                 with: user.email
        fill_in "Password",              with: user.password
        fill_in "Password confirmation", with: user.password

        click_button 'Sign up'
      end

      it 'should create a new user' do
        expect(User.count).to eq 1

        created_user = User.last
        expect(created_user.first_name).to eq user.first_name
        expect(created_user.last_name).to eq user.last_name
        expect(created_user.email).to eq user.email
        expect(created_user.valid_password?(user.password)).to be_truthy
      end

      it 'should redirect to home page, authenticated' do
        expect(page).to have_link 'Sign Out'
        expect(page).to have_text user.to_s

        expect(page).not_to have_link 'Sign In'
        expect(page).not_to have_link 'Sign Up'
      end

    end

    context 'invalid submission' do

      before :each do
        visit new_user_registration_path
        click_button 'Sign up'
      end

      it 'should not create a new user' do
        expect(User.count).to eq 0
      end

      it 'should redirect to sign up form' do
        expect(page).to have_button 'Sign up'
      end

      it 'should display errors' do
        expect(page).to have_text "Email can't be blank"
        expect(page).to have_text "First name can't be blank"
        expect(page).to have_text "Last name can't be blank"
        expect(page).to have_text "Password can't be blank"
      end

    end

  end

  describe 'sign in' do

    let(:user) { create(:user) }

    context 'valid submission' do

      before :each do
        visit new_user_session_path

        fill_in "Email",                 with: user.email
        fill_in "Password",              with: user.password

        click_button 'Log in'
      end

      it 'should authenticate' do
        expect(page).to have_link 'Sign Out'
        expect(page).to have_text user.to_s

        expect(page).not_to have_link 'Sign In'
        expect(page).not_to have_link 'Sign Up'
      end

    end

    context 'invalid submission' do

      context 'invalid email' do

        before :each do
          visit new_user_session_path

          fill_in "Email",                 with: user.email + 'a'
          fill_in "Password",              with: user.password

          click_button 'Log in'
        end

        it 'should render sign in form' do
          expect(page).to have_button 'Log in'
        end

        it 'should not authenticate' do
          expect(page).not_to have_link 'Sign Out'
          expect(page).not_to have_text user.to_s

          expect(page).to have_link 'Sign In'
          expect(page).to have_link 'Sign Up'
        end

        it 'should display an error' do
          expect(page).to have_text 'Invalid Email or password.'
        end

      end

      context 'invalid password' do

        before :each do
          visit new_user_session_path

          fill_in "Email",                 with: user.email
          fill_in "Password",              with: user.password + 'a'

          click_button 'Log in'
        end

        it 'should render sign in form' do
          expect(page).to have_button 'Log in'
        end

        it 'should not authenticate' do
          expect(page).not_to have_link 'Sign Out'
          expect(page).not_to have_text user.to_s

          expect(page).to have_link 'Sign In'
          expect(page).to have_link 'Sign Up'
        end

        it 'should display an error' do
          expect(page).to have_text 'Invalid Email or password.'
        end

      end

    end

  end

  describe 'sign out' do

    let(:user) { create(:user) }

    before :each { login_as user, scope: :user }

    it 'should disconnect' do
      visit root_path
      click_link 'Sign Out'

      expect(page).not_to have_link 'Sign Out'
      expect(page).not_to have_text user.to_s

      expect(page).to have_link 'Sign In'
      expect(page).to have_link 'Sign Up'
    end

  end

end
