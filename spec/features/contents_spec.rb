require 'rails_helper'

RSpec.feature "Contents", type: :feature do

  let(:user_1) { create(:user) }

  describe 'list' do

    let(:user_2) { create(:user_edited) }

    let!(:source_1) { create(:rss_source, user: user_1) }
    let!(:source_2) { create(:rss_source_edited, user: user_2) }

    let!(:content_1) { create(:content, user: user_1, source: source_1) }
    let!(:content_2) { create(:content_edited, user: user_2, source: source_2) }

    describe 'unauthenticated' do

      it 'should redirect to login page' do
        visit contents_path

        expect(page.status_code).to eq 200
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

    end

    describe 'authenticated' do

      before :each do
        login_as user_1, scope: :user
        visit contents_path
      end

      it 'should work' do
        expect(page.status_code).to eq 200
        expect(current_path).to eq contents_path
      end

      it 'should display the user source' do
        expect(page).to have_link content_1.title, href: content_1.url
        expect(page).to have_content content_1.description
        expect(page).to have_content content_1.source.name
      end

      it 'should not display the other user source' do
        expect(page).not_to have_link content_2.title, href: content_2.url
        expect(page).not_to have_content content_2.description
        expect(page).not_to have_content content_2.source.name
      end

    end

  end

end
