require 'rails_helper'

RSpec.describe ContentsController, type: :controller do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user_edited) }

  let!(:source_1) { create(:rss_source, user: user_1) }
  let!(:source_2) { create(:rss_source, user: user_2) }

  let!(:content_1) { create(:content, user: user_1, source: source_1) }
  let!(:content_2) { create(:content_edited, user: user_1, source: source_1) }
  let!(:content_3) { create(:content_edited_2, user: user_2, source: source_2) }

  describe 'index' do

    describe 'unauthenticated' do

      it 'should not be permitted' do
        get :index, params: {category: :inbox}
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      it 'should work' do
        get :index, params: {category: :inbox}
        expect(response.status).to eq 200
        expect(response).to render_template :index
      end

      it 'should list current_user contents' do
        get :index, params: {category: :inbox}
        expect(assigns(:contents)).not_to be_nil
        expect(assigns(:contents).count).to eq 2
        expect(assigns(:contents)).to eq [content_2, content_1]
      end

      it 'should order by created_at desc' do
      end

    end

  end

end
