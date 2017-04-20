require 'rails_helper'

RSpec.feature "Sources", type: :feature do

  let(:user_1) { create(:user) }

  describe 'list' do

    let(:user_2) { create(:user_edited) }

    let!(:source_1) { create(:rss_source, user: user_1) }
    let!(:source_2) { create(:rss_source_edited, user: user_2) }

    describe 'unauthenticated' do

      it 'should redirect to login page' do
        visit sources_path

        expect(page.status_code).to eq 200
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

    end

    describe 'authenticated' do

      before(:each) do
        login_as user_1, scope: :user
        visit sources_path
      end

      it 'should work' do
        expect(page.status_code).to eq 200
        expect(current_path).to eq sources_path
      end

      it 'should display the user source' do
        expect(page).to have_content source_1.name
        expect(page).to have_content source_1.description
      end

      it 'should not display the other user source' do
        expect(page).not_to have_content source_2.name
        expect(page).not_to have_content source_2.description
      end

    end

  end

  describe 'create' do

    let!(:source_1) { build(:rss_source, user: user_1) }

    describe 'unauthenticated' do

      it 'should redirect to login page' do
        visit new_source_path

        expect(page.status_code).to eq 200
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

    end

    describe 'authenticated' do

      describe 'with valid data' do

        before(:each) do
          login_as user_1, scope: :user
          visit new_source_path

          fill_in 'Name',         with: source_1.name
          fill_in 'Description',  with: source_1.description
          fill_in 'URL',          with: source_1.url
          fill_in 'RSS Feed URL', with: source_1.rss_feed
          select  I18n.t("models.source.#{source_1.type.underscore}"),  from: 'source_type'

          click_button 'Submit'
        end

        it 'should work' do
          expect(page.status_code).to eq 200
          expect(current_path).to eq sources_path
        end

        it 'should display the user source' do
          expect(page).to have_content source_1.name
          expect(page).to have_content source_1.description
        end

        it 'should create the source' do
          expect(Source.count).to eq 1
          expect(user_1.reload.sources.count).to eq 1

          created_source = user_1.reload.sources.first
          expect(created_source.name).to        eq source_1.name
          expect(created_source.description).to eq source_1.description
          expect(created_source.url).to         eq source_1.url
          expect(created_source.rss_feed).to    eq source_1.rss_feed
          expect(created_source.type).to        eq source_1.type
        end

      end

      describe 'with invalid data' do

        before(:each) do
          login_as user_1, scope: :user
          visit new_source_path

          fill_in 'Name',         with: ''
          fill_in 'Description',  with: ''
          fill_in 'URL',          with: 'bla bla bla'
          fill_in 'RSS Feed URL', with: 'bla bla bla'
          select  I18n.t("models.source.#{source_1.type.underscore}"),  from: 'Type'

          click_button 'Submit'
        end

        it 'should work' do
          expect(page.status_code).to eq 400
          expect(current_path).to eq sources_path
          expect(page).to have_content "Create a content source"
          expect(page).to have_selector 'form'
        end

        it 'should display the errors' do
          expect(page).to have_content "Name can't be blank"
          expect(page).to have_content "URL is invalid"
          expect(page).to have_content "RSS Feed URL is invalid"
        end

        it 'should not have created the source' do
          expect(Source.count).to eq 0
          expect(user_1.reload.sources.count).to eq 0
        end

      end

    end

  end

  describe 'update' do

    let(:user_2) { create(:user_edited) }

    let!(:source_1) { create(:rss_source, user: user_1) }
    let!(:source_2) { create(:rss_source, user: user_2) }

    describe 'unauthenticated' do

      it 'should redirect to login page' do
        visit edit_source_path source_1

        expect(page.status_code).to eq 200
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content 'You need to sign in or sign up before continuing.'
      end

    end

    describe 'authenticated' do

      before(:each) { login_as user_1, scope: :user }

      describe 'with owned source' do

        describe 'when changing type' do

          describe 'with valid data' do

            let(:source_edited) { build(:youtube_source) }

            before(:each) do
              visit edit_source_path source_1

              fill_in 'Name',             with: source_edited.name
              fill_in 'Description',      with: source_edited.description
              fill_in 'URL',              with: source_edited.url
              fill_in 'RSS Feed URL',     with: source_edited.rss_feed
              select  I18n.t("models.source.#{source_edited.type.underscore}"), from: 'Type'

              click_button 'Submit'
            end

            it 'should work' do
              expect(page.status_code).to eq 200
              expect(current_path).to eq sources_path
            end

            it 'should display the edited user source' do
              expect(page).to have_content source_edited.name
              expect(page).to have_content source_edited.description
            end

            it 'should have updated the source' do
              expect(user_1.sources.count).to eq 1

              source = user_1.sources.first

              expect(source.name).to        eq source_edited.name
              expect(source.description).to eq source_edited.description
              expect(source.url).to         eq source_edited.url
              expect(source.rss_feed).to    eq source_edited.rss_feed
              expect(source.type).to        eq source_edited.type
            end

          end

          describe 'with invalid data' do

            let!(:source_3) { create(:youtube_source, user: user_1) }

            before(:each) do
              visit edit_source_path source_3

              # Then try to submit by setting again RSS, but without the URL
              select I18n.t("models.source.source/rss"), from: 'Type'

              click_button 'Submit'
            end

            it 'should not work' do
              expect(page.status_code).to eq 400
              expect(page).to have_content "Edit a content source"
              expect(page).to have_selector 'form'
            end

            it 'should display the errors' do
              expect(page).to have_content "RSS Feed URL is invalid"
            end

            it 'should not have updated the source' do
              source_3.reload
              expect(source_3.type).to eq 'Source::Youtube'
            end

          end

        end

        describe 'with valid data' do

          let(:source_edited) { build(:rss_source_edited) }

          before(:each) do
            visit edit_source_path source_1

            fill_in 'Name',             with: source_edited.name
            fill_in 'Description',      with: source_edited.description
            fill_in 'URL',              with: source_edited.url
            fill_in 'RSS Feed URL',     with: source_edited.rss_feed
            select  I18n.t("models.source.#{source_edited.type.underscore}"), from: 'Type'

            click_button 'Submit'
          end

          it 'should work' do
            expect(page.status_code).to eq 200
            expect(current_path).to eq sources_path
          end

          it 'should display the edited user source' do
            expect(page).to have_content source_edited.name
            expect(page).to have_content source_edited.description
          end

          it 'should have updated the source' do
            source_1.reload
            expect(source_1.name).to        eq source_edited.name
            expect(source_1.description).to eq source_edited.description
            expect(source_1.url).to         eq source_edited.url
            expect(source_1.rss_feed).to    eq source_edited.rss_feed
            expect(source_1.type).to        eq source_edited.type
          end

        end

        describe 'with invalid data' do

          before(:each) do
            visit edit_source_path source_1

            fill_in 'Name',         with: ''
            fill_in 'Description',  with: ''
            fill_in 'URL',          with: 'bla bla bla'
            fill_in 'RSS Feed URL', with: 'bla bla bla'
            select  I18n.t("models.source.#{source_1.type.underscore}"),  from: 'Type'

            click_button 'Submit'
          end

          it 'should not work' do
            expect(page.status_code).to eq 400
            expect(page).to have_content "Edit a content source"
            expect(page).to have_selector 'form'
          end

          it 'should display the errors' do
            expect(page).to have_content "Name can't be blank"
            expect(page).to have_content "URL is invalid"
            expect(page).to have_content "RSS Feed URL is invalid"
          end

          it 'should not have updated the source' do
            source = user_1.reload.sources.first
            expect(source.name).not_to        eq ''
            expect(source.description).not_to eq ''
            expect(source.url).not_to         eq 'bla bla bla'
            expect(source.rss_feed).not_to    eq 'bla bla bla'
          end

        end

      end

      describe 'with someone else source' do

        it 'should not work' do
          visit edit_source_path source_2

          expect(page.status_code).to eq 200
          expect(current_path).to eq contents_path
          expect(page).to have_content 'The requested source does not exist or does not belong to you'
        end

      end

    end

  end

  describe 'destroy' do

    # no unauthenticated tests since it requires to access the list page first

    let!(:source_1) { create(:rss_source, user: user_1) }

    before(:each) do
      login_as user_1, scope: :user
      visit sources_path
      find('.delete_source_link').click
    end

    it 'should work' do
      expect(page.status_code).to eq 200
      expect(current_path).to eq sources_path
    end

    it 'should not display the source anymore' do
      expect(page).not_to have_content source_1.name
      expect(page).not_to have_content source_1.description

      expect(page).to have_content 'No source'
    end

    it 'should have remove the source' do
      expect(Source.count).to eq 0
    end

  end

end
