require 'rails_helper'

RSpec.describe ContentsController, type: :controller do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user_edited) }

  let!(:source_1) { create(:rss_source, user: user_1) }
  let!(:source_2) { create(:rss_source, user: user_2) }

  let!(:content_1) { create(:content, user: user_1, source: source_1) }
  let!(:content_2) { create(:content, user: user_2, source: source_2) }

  describe 'index' do

    describe 'unauthenticated' do

      it 'should not be permitted' do
        get :index
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before :each { sign_in user_1 }

      it 'should work' do
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template :index
      end

      it 'should list current_user sources' do
        get :index
        expect(assigns(:contents)).not_to be_nil
        expect(assigns(:contents).count).to eq 1
        expect(assigns(:contents).first).to eq content_1
      end

    end

  end

end
