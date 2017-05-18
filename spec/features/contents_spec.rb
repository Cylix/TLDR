require 'rails_helper'

# time_ago_in_words
require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

RSpec.feature "Contents", type: :feature do

  let(:user_1) { create(:user) }

  describe 'list' do

    let(:user_2) { create(:user_edited) }

    let!(:source_1) { create(:rss_source, user: user_1) }
    let!(:source_2) { create(:rss_source_edited, user: user_2) }

    # content number 1, no publication date information
    let!(:content_1) { create(:content, user: user_1, source: source_1, published_at: nil) }
    # content number 1, with publication date information
    let!(:content_2) { create(:content_edited, user: user_1, source: source_1, published_at: Time.now) }
    let!(:content_3) { create(:content_edited_2, user: user_2, source: source_2) }

    describe 'unauthenticated' do

      it 'should redirect to login page' do
        visit contents_path

        expect(page.status_code).to eq 200
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

    end

    describe 'authenticated' do

      before(:each) do
        login_as user_1, scope: :user
        visit contents_path
      end

      it 'should work' do
        expect(page.status_code).to eq 200
        expect(current_path).to eq filter_contents_path(:inbox)
      end

      it 'should display the user source' do
        expect(page).to have_link I18n.t("views.contents.index.view_content"), href: content_1.url
        expect(page).to have_content content_1.title
        expect(page).to have_content content_1.description
        expect(page).to have_content content_1.source.name
        expect(page).to have_content I18n.t('views.contents.index.imported_at', synchronized_at: ActionView::Helpers::DateHelper::time_ago_in_words(content_1.synchronized_at))

        expect(page).to have_link I18n.t("views.contents.index.view_content"), href: content_2.url
        expect(page).to have_content content_2.title
        expect(page).to have_content content_2.description
        expect(page).to have_content content_2.source.name
        expect(page).to have_content I18n.t('views.contents.index.pusblished_and_imported_at', published_at: ActionView::Helpers::DateHelper::time_ago_in_words(content_2.published_at), synchronized_at: time_ago_in_words(content_2.synchronized_at))
      end

      it 'should not display the other user source' do
        expect(page).not_to have_link I18n.t("views.contents.index.view_content"), href: content_3.url
        expect(page).not_to have_content content_3.title
        expect(page).not_to have_content content_3.description
        expect(page).not_to have_content content_3.source.name
      end

      it 'should be ordered by created_at DESC' do
        expect(page.body).to match /.*#{content_2.title}.*#{content_1.title}.*/
      end

    end

  end

end
