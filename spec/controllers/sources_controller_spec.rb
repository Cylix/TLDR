require 'rails_helper'

RSpec.describe SourcesController, type: :controller do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user_edited) }

  let!(:source_1) { create(:rss_source, user: user_1) }
  let!(:source_2) { create(:rss_source, user: user_2) }

  describe 'index' do

    describe 'unauthenticated' do

      it 'should not be permitted' do
        get :index
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      it 'should work' do
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template :index
      end

      it 'should list current_user sources' do
        get :index
        expect(assigns(:sources)).not_to be_nil
        expect(assigns(:sources).count).to eq 1
        expect(assigns(:sources).first).to eq source_1
      end

    end

  end

  describe 'new' do

    describe 'unauthenticated' do

      it 'should not be permitted' do
        get :new
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      it 'should work' do
        get :new
        expect(response.status).to eq 200
        expect(response).to render_template :new
      end

      it 'should build a new source' do
        get :new
        expect(assigns(:source)).not_to be_nil
        expect(assigns(:source).attributes).to eq Source.new.attributes
      end

    end

  end

  describe 'create' do

    let(:new_source) { build(:rss_source_edited) }

    describe 'unauthenticated' do

      it 'should not be permitted' do
        post :create, params: { source: new_source.attributes }
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      describe 'with valid data' do

        it 'should work' do
          post :create, params: { source: new_source.attributes }
          expect(response.status).to eq 302
          expect(response).to redirect_to action: :index
          expect(flash[:success]).not_to be_nil
        end

        it 'should create a new source for the current user with the requested data' do
          expect {
            post :create, params: { source: new_source.attributes }
          }.to change{ user_1.sources.count }.by 1

          created_source = user_1.sources.last
          expect(created_source.name).to        eq new_source.name
          expect(created_source.description).to eq new_source.description
          expect(created_source.url).to         eq new_source.url
          expect(created_source.rss_feed).to    eq new_source.rss_feed
          expect(created_source.type).to        eq new_source.type
        end

      end

      describe 'with invalid data' do

        before(:each) { new_source.name = '' }

        it 'should work' do
          post :create, params: { source: new_source.attributes }
          expect(response.status).to eq 400
          expect(response).to render_template :new
          expect(flash[:resource_errors]).not_to be_nil
        end

        it 'should not create a new source' do
          expect {
            post :create, params: { source: new_source.attributes }
          }.not_to change{ Source.count }
        end

      end

    end

  end

  describe 'edit' do

    describe 'unauthenticated' do

      it 'should not be permitted' do
        get :edit, params: { id: source_1.id }
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      describe 'to edit owned source' do

        it 'should work' do
          get :edit, params: { id: source_1.id }
          expect(response.status).to eq 200
          expect(response).to render_template :edit
        end

        it 'should provide the corresponding source' do
          get :edit, params: { id: source_1.id }
          expect(assigns(:source)).not_to be_nil
          expect(assigns(:source)).to eq source_1
        end

      end

      describe 'to edit someone else source' do

        it 'should not be permitted' do
          get :edit, params: { id: source_2.id }
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end

        it 'should provide an explanation' do
          get :edit, params: { id: source_2.id }
          expect(flash[:error]).not_to be_nil
        end

      end

    end

  end

  describe 'update' do

    let(:new_source) { build(:rss_source_edited) }

    describe 'unauthenticated' do

      it 'should not be permitted' do
        put :update, params: { id: source_1.id, source: new_source.attributes }
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      describe 'to update owned source' do

        describe 'when changing type' do

          describe 'with valid data' do

            let(:source_edited) { build(:youtube_source) }

            it 'should work' do
              put :update, params: { id: source_1.id, source: source_edited.attributes }
              expect(response.status).to eq 302
              expect(response).to redirect_to action: :index
              expect(flash[:success]).not_to be_nil
            end

            it 'should udpate the requested resource' do
              put :update, params: { id: source_1.id, source: source_edited.attributes }

              source = user_1.sources.first

              expect(source.name).to          eq source_edited.name
              expect(source.description).to   eq source_edited.description
              expect(source.url).to           eq source_edited.url
              expect(source.rss_feed).to      eq source_edited.rss_feed
              expect(source.type).to          eq source_edited.type
            end

          end

          describe 'with invalid data' do

            let(:source_edited) { build(:rss_source) }
            let!(:source_3) { create(:youtube_source, user: user_1) }

            before(:each) { source_edited.rss_feed = '' }

            it 'should not work' do
              put :update, params: { id: source_3.id, source: source_edited.attributes }
              expect(response.status).to eq 400
              expect(response).to render_template :edit
              expect(flash[:resource_errors]).not_to be_nil
            end

            it 'should not udpate the requested resource' do
              expect {
                put :update, params: { id: source_3.id, source: source_edited.attributes }
              }.not_to change{ source_3.reload }
            end

          end

        end

        describe 'with valid data' do

          it 'should work' do
            put :update, params: { id: source_1.id, source: new_source.attributes }
            expect(response.status).to eq 302
            expect(response).to redirect_to action: :index
            expect(flash[:success]).not_to be_nil
          end

          it 'should udpate the requested resource' do
            put :update, params: { id: source_1.id, source: new_source.attributes }

            source_1.reload
            expect(source_1.name).to        eq new_source.name
            expect(source_1.description).to eq new_source.description
            expect(source_1.url).to         eq new_source.url
            expect(source_1.rss_feed).to    eq new_source.rss_feed
            expect(source_1.type).to        eq new_source.type
          end

        end

        describe 'with invalid data' do

          before(:each) { new_source.name = '' }

          it 'should work' do
            put :update, params: { id: source_1.id, source: new_source.attributes }
            expect(response.status).to eq 400
            expect(response).to render_template :edit
            expect(flash[:resource_errors]).not_to be_nil
          end

          it 'should not udpate the requested resource' do
            expect {
              put :update, params: { id: source_1.id, source: new_source.attributes }
            }.not_to change{ source_1.reload }
          end

        end

      end

      describe 'to update someone else source' do

        it 'should not work' do
          put :update, params: { id: source_2.id, source: new_source.attributes }
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
          expect(flash[:error]).not_to be_nil
        end

        it 'should not udpate the requested resource' do
          expect{
            put :update, params: { id: source_2.id, source: new_source.attributes }
          }.not_to change{ source_2.reload }
        end

      end

    end

  end

  describe 'destroy' do

    describe 'unauthenticated' do

      it 'should not be permitted' do
        delete :destroy, params: { id: source_1.id }
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      describe 'to destroy owned source' do

        it 'should work' do
          delete :destroy, params: { id: source_1.id }
          expect(response.status).to eq 302
          expect(response).to redirect_to action: :index
          expect(flash[:success]).not_to be_nil
        end

        it 'should destroy the requested resource' do
          expect{
            delete :destroy, params: { id: source_1.id }
          }.to change{ user_1.sources.count }.by -1
        end

      end

      describe 'to edit someone else source' do

        it 'should not work' do
          delete :destroy, params: { id: source_2.id }
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
          expect(flash[:error]).not_to be_nil
        end

        it 'should not destroy the requested resource' do
          expect{
            delete :destroy, params: { id: source_2.id }
          }.not_to change{ Source.count }
        end

      end

    end

  end

end
