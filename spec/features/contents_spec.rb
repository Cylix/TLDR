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

  describe 'pin' do

    before(:each) { login_as user_1, scope: :user }

    let!(:source_1) { create(:rss_source, user: user_1) }

    let!(:content_1) { create(:content, user: user_1, source: source_1, title: 'CONTENT_1') }
    let!(:content_2) { create(:content_edited, user: user_1, source: source_1, title: 'CONTENT_2') }

    describe 'order' do

      context 'before' do

        it 'should order created_at DESC' do
          visit filter_contents_path(:inbox)
          expect(page).to have_content /CONTENT_2.*CONTENT_1/
        end

      end

      context 'after' do

        before do
          visit filter_contents_path(:inbox)
          all('a.pin_btn').last.click
        end

        it 'should show pin first' do
          visit filter_contents_path(:inbox)
          expect(page).to have_content /CONTENT_1.*CONTENT_2/
        end

      end

    end

    describe 'pin' do

      context 'before' do

        it 'should have 2 pinned item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.pin_btn i', count: 2) # nb items
          expect(page).to have_selector('a.pin_btn i.text-info', count: 0) # nb pinned
        end

      end

      context 'after' do

        before(:each) do
          visit filter_contents_path(:inbox)
          first('a.pin_btn').click
        end

        it 'should have 1 pinned item' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.pin_btn i', count: 2) # nb items
          expect(page).to have_selector('a.pin_btn i.text-info', count: 1) # nb pinned
        end

        it 'should update the content is DB' do
          expect(content_1.reload.is_pinned).to eq false
          expect(content_2.reload.is_pinned).to eq true
        end

      end

      end

      describe 'unpin' do

      before(:each) do
        visit filter_contents_path(:inbox)
        first('a.pin_btn').click
      end

      context 'before' do

        it 'should have 1 undone item' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.pin_btn i', count: 2) # nb items
          expect(page).to have_selector('a.pin_btn i.text-info', count: 1) # nb pinned
        end

      end

      context 'after' do

        before(:each) do
          visit filter_contents_path(:inbox)
          first('a.pin_btn').click
        end

        it 'should have 2 untrashed item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.pin_btn i', count: 2) # nb items
          expect(page).to have_selector('a.pin_btn i.text-info', count: 0) # nb pinned
        end

      end

    end

  end

  describe 'trash' do

    before(:each) { login_as user_1, scope: :user }

    let!(:source_1) { create(:rss_source, user: user_1) }

    let!(:content_1) { create(:content, user: user_1, source: source_1, title: 'CONTENT_1') }
    let!(:content_2) { create(:content_edited, user: user_1, source: source_1, title: 'CONTENT_2') }

    describe 'trash' do

      context 'before' do

        it 'should have 2 untrashed item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.trashed_btn i', count: 2) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 0) # nb trashed
          expect(page).to have_content('CONTENT_1')
          expect(page).to have_content('CONTENT_2')
        end

        it 'should have no trashed item in trash' do
          visit filter_contents_path(:trashed)
          expect(page).to have_selector('a.trashed_btn i', count: 0) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 0) # nb trashed
        end

      end

      context 'after' do

        before(:each) do
          visit filter_contents_path(:inbox)
          first('a.trashed_btn').click
        end

        it 'should have 1 untrashed item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.trashed_btn i', count: 1) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 0) # nb trashed
          expect(page).to have_content('CONTENT_1')
        end

        it 'should have 1 trashed item in trash' do
          visit filter_contents_path(:trashed)
          expect(page).to have_selector('a.trashed_btn i', count: 1) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 1) # nb trashed
          expect(page).to have_content('CONTENT_2')
        end

        it 'should update the content is DB' do
          expect(content_1.reload.category).to eq "inbox"
          expect(content_2.reload.category).to eq "trashed"
        end

      end

    end

    describe 'untrash' do

      before(:each) do
        visit filter_contents_path(:inbox)
        first('a.trashed_btn').click
      end

      context 'before' do

        it 'should have 1 untrashed item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.trashed_btn i', count: 1) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 0) # nb trashed
          expect(page).to have_content('CONTENT_1')
        end

        it 'should have 1 trashed item in trash' do
          visit filter_contents_path(:trashed)
          expect(page).to have_selector('a.trashed_btn i', count: 1) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 1) # nb trashed
          expect(page).to have_content('CONTENT_2')
        end

      end

      context 'after' do

        before(:each) do
          visit filter_contents_path(:trashed)
          first('a.trashed_btn').click
        end

        it 'should have 2 untrashed item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.trashed_btn i', count: 2) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 0) # nb trashed
          expect(page).to have_content('CONTENT_1')
          expect(page).to have_content('CONTENT_2')
        end

        it 'should have no trashed item in trash' do
          visit filter_contents_path(:trashed)
          expect(page).to have_selector('a.trashed_btn i', count: 0) # nb items
          expect(page).to have_selector('a.trashed_btn i.text-danger', count: 0) # nb trashed
        end

      end

    end

  end

  describe 'done' do

    before(:each) { login_as user_1, scope: :user }

    let!(:source_1) { create(:rss_source, user: user_1) }

    let!(:content_1) { create(:content, user: user_1, source: source_1, title: 'CONTENT_1') }
    let!(:content_2) { create(:content_edited, user: user_1, source: source_1, title: 'CONTENT_2') }

    describe 'done' do

      context 'before' do

        it 'should have 2 undone item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.done_btn i', count: 2) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 0) # nb done
          expect(page).to have_content('CONTENT_1')
          expect(page).to have_content('CONTENT_2')
        end

        it 'should have no done item in done' do
          visit filter_contents_path(:done)
          expect(page).to have_selector('a.done_btn i', count: 0) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 0) # nb done
        end

      end

      context 'after' do

        before(:each) do
          visit filter_contents_path(:inbox)
          first('a.done_btn').click
        end

        it 'should have 1 undone item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.done_btn i', count: 1) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 0) # nb done
          expect(page).to have_content('CONTENT_1')
        end

        it 'should have 1 done item in done' do
          visit filter_contents_path(:done)
          expect(page).to have_selector('a.done_btn i', count: 1) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 1) # nb done
          expect(page).to have_content('CONTENT_2')
        end

        it 'should update the content is DB' do
          expect(content_1.reload.category).to eq "inbox"
          expect(content_2.reload.category).to eq "done"
        end

      end

    end

    describe 'undone' do

      before(:each) do
        visit filter_contents_path(:inbox)
        first('a.done_btn').click
      end

      context 'before' do

        it 'should have 1 undone item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.done_btn i', count: 1) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 0) # nb done
          expect(page).to have_content('CONTENT_1')
        end

        it 'should have 1 done item in done' do
          visit filter_contents_path(:done)
          expect(page).to have_selector('a.done_btn i', count: 1) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 1) # nb done
          expect(page).to have_content('CONTENT_2')
        end

      end

      context 'after' do

        before(:each) do
          visit filter_contents_path(:done)
          first('a.done_btn').click
        end

        it 'should have 2 untrashed item in inbox' do
          visit filter_contents_path(:inbox)
          expect(page).to have_selector('a.done_btn i', count: 2) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 0) # nb done
          expect(page).to have_content('CONTENT_1')
          expect(page).to have_content('CONTENT_2')
        end

        it 'should have no done item in done' do
          visit filter_contents_path(:done)
          expect(page).to have_selector('a.done_btn i', count: 0) # nb items
          expect(page).to have_selector('a.done_btn i.text-success', count: 0) # nb done
        end

      end

    end

  end

end
