require 'rails_helper'

RSpec.describe ContentsController, type: :controller do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user_edited) }

  let!(:source_1) { create(:rss_source, user: user_1) }
  let!(:source_2) { create(:rss_source, user: user_2) }
  let!(:source_3) { create(:rss_source, user: user_1) }

  let!(:content_1) { create(:content, user: user_1, source: source_1) }
  let!(:content_2) { create(:content_edited, user: user_1, source: source_3, is_pinned: true) }
  let!(:content_3) { create(:content_edited_2, user: user_2, source: source_2) }
  let!(:content_4) { create(:content_edited_2, user: user_1, source: source_1, category: :snoozed) }

  # USER 1
  #  content_1    source_1      unpinned      inbox
  #  content_2    source_3      pinned        inbox
  #  content_4    source_1      unpinned      snoozed
  #
  # USER 2
  #  content_3    source_2      unpinned      inbox

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

    end

    describe 'filtering' do

      before(:each) { sign_in user_1 }

      describe 'source filtering' do

        describe 'when source exists' do

          it 'should list the sources of the given source' do
            get :index, params: {source_id: source_1.id}
            expect(assigns(:contents)).not_to be_nil
            expect(assigns(:contents).count).to eq 2
            expect(assigns(:contents)).to eq [content_4, content_1]
          end

        end

        describe 'when source does not exist' do

          it 'should redirect to the inbox page' do
            get :index, params: {source_id: source_3.id + 1}
            expect(response.status).to eq 302
            expect(response).to redirect_to filter_contents_path(:inbox)
          end

        end

        describe 'when source belongs to another user' do

          it 'should redirect to the inbox page' do
            get :index, params: {source_id: source_2.id}
            expect(response.status).to eq 302
            expect(response).to redirect_to filter_contents_path(:inbox)
          end

        end

      end

      describe 'category filtering' do

        describe 'with a valid category' do

          it 'should list the sources of the given category' do
            get :index, params: {category: :snoozed}
            expect(assigns(:contents)).not_to be_nil
            expect(assigns(:contents).count).to eq 1
            expect(assigns(:contents)).to eq [content_4]
          end

        end

        describe 'with an invalid category' do

          it 'should redirect to the inbox page' do
            get :index, params: {category: :yolo}
            expect(response.status).to eq 302
            expect(response).to redirect_to filter_contents_path(:inbox)
          end

        end

      end

      describe 'no filtering' do

        it 'should redirect to the inbox page' do
          get :index
          expect(response.status).to eq 302
          expect(response).to redirect_to filter_contents_path(:inbox)
        end

      end

    end

    describe 'ordering' do

      # Ordering is actually test in the other tests
      # Indeed, filtering tests sometimes returns multiple records
      # In such case, ordering is checked

    end

    describe 'pinned' do

      before(:each) { sign_in user_1 }

      it 'should split pin and unpin' do
        get :index, params: {category: :inbox}

        expect(assigns(:pinned)).not_to be_nil
        expect(assigns(:pinned).count).to eq 1
        expect(assigns(:pinned)).to eq [content_2]

        expect(assigns(:unpinned)).not_to be_nil
        expect(assigns(:unpinned).count).to eq 1
        expect(assigns(:unpinned)).to eq [content_1]
      end

    end

  end

  describe 'update' do

    let!(:source_for_edit) { create(:rss_source, user: user_1) }
    let!(:edited_content) { create(:content_edited, user: user_1, source: source_for_edit, is_pinned: !content_1.is_pinned, category: :trashed) }

    def update_params
      { content: edited_content.attributes.slice("title", "description", "url", "published_at", "synchronized_at", "is_pinned", "category") }
    end

    describe 'unauthenticated' do

      it 'should not be permitted' do
        put :update, params: {id: content_1.id}.merge(update_params)
        expect(response.status).to eq 302
        expect(response).to redirect_to new_user_session_path
      end

    end

    describe 'authenticated' do

      before(:each) { sign_in user_1 }

      describe 'for current user' do

        def filter_output(obj)
          obj.except("created_at", "updated_at", "published_at", "synchronized_at")
        end

        describe 'with valid data' do

          it 'should work' do
            put :update, params: {id: content_1.id}.merge(update_params)
            expect(response.status).to eq 200
            expect(response.header['Content-Type']).to include 'application/json'

            parsed = JSON.parse(response.body)
            expect(parsed["success"]).to be_truthy
            expect(parsed["content"]).not_to be_nil
            expect(filter_output(parsed["content"])).to eq filter_output(content_1.reload.as_json)
          end

          it 'should udpate the requested resource, but only for authorized fields' do
            put :update, params: {id: content_1.id}.merge(update_params)

            content = content_1.reload

            # Authorized
            expect(content.is_pinned).to  eq edited_content.is_pinned
            expect(content.category).to   eq edited_content.category

            # Unauthorized
            expect(content.title).not_to            eq edited_content.title
            expect(content.description).not_to      eq edited_content.description
            expect(content.url).not_to              eq edited_content.url
            expect(content.published_at).not_to     eq edited_content.published_at
            expect(content.synchronized_at).not_to  eq edited_content.synchronized_at
          end

        end

        describe 'with invalid data (throwing exception)' do

          let(:invalid_update_params) do
            params = update_params
            params[:content]["category"] = "yolo"
            params
          end

          it 'should not work' do
            put :update, params: {id: content_1.id}.merge(invalid_update_params)
            expect(response.status).to eq 400
            expect(response.header['Content-Type']).to include 'application/json'

            parsed = JSON.parse(response.body)
            expect(parsed["success"]).to be_falsey
            expect(parsed["message"]).not_to be_nil
          end

          it 'should not udpate the requested resource' do
            expect {
              put :update, params: {id: content_1.id}.merge(invalid_update_params)
            }.not_to change{ source_1.reload }
          end

        end

        describe 'with invalid data (valid? is false)' do

          let(:invalid_update_params) do
            params = update_params
            params[:content]["is_pinned"] = nil
            params
          end

          it 'should not work' do
            put :update, params: {id: content_1.id}.merge(invalid_update_params)
            expect(response.status).to eq 400
            expect(response.header['Content-Type']).to include 'application/json'

            parsed = JSON.parse(response.body)
            expect(parsed["success"]).to be_falsey
            expect(parsed["message"]).not_to be_nil
          end

          it 'should not udpate the requested resource' do
            expect {
              put :update, params: {id: content_1.id}.merge(invalid_update_params)
            }.not_to change{ source_1.reload }
          end

        end

        describe 'for unexisting record' do

          it 'should redirect to root path' do
            put :update, params: {id: content_4.id + 10}.merge(update_params)
            expect(response.status).to eq 302
            expect(response).to redirect_to root_path
          end

        end

      end

      describe 'for another user' do

        it 'should not be permitted' do
          put :update, params: {id: content_3.id}.merge(update_params)
          expect(response.status).to eq 302
          expect(response).to redirect_to root_path
        end

      end

    end

  end

end
