require 'rails_helper'

RSpec.feature "Synchronizer", type: :feature do

  let!(:user) { create(:user) }
  let!(:source) { create(:rss_source, user: user) }
  let!(:content) { create(:content, user: user, source: source) }

  describe 'already_synchronized?' do

    context 'with match' do

      let(:new_content) { Content.new title:        content.title,
                                      description:  content.description,
                                      url:          content.url,
                                      published_at: content.published_at,
                                      source_id:    source.id,
                                      user_id:      user.id }

      it 'should return true' do
        expect(Synchronizer.new(source).send :already_synchronized?, new_content).to be_truthy
      end

    end

    context 'with mismatch' do

      context 'with different title' do

        let(:new_content) { Content.new title:        content.title * 2,
                                        description:  content.description,
                                        url:          content.url,
                                        published_at: content.published_at,
                                        source_id:    source.id,
                                        user_id:      user.id }

        it 'should return false' do
          expect(Synchronizer.new(source).send :already_synchronized?, new_content).to be_falsey
        end

      end

      context 'with different description' do

        let(:new_content) { Content.new title:        content.title,
                                        description:  content.description * 2,
                                        url:          content.url,
                                        published_at: content.published_at,
                                        source_id:    source.id,
                                        user_id:      user.id }

        it 'should return false' do
          expect(Synchronizer.new(source).send :already_synchronized?, new_content).to be_falsey
        end

      end

      context 'with different url' do

        let(:new_content) { Content.new title:        content.title,
                                        description:  content.description,
                                        url:          content.url * 2,
                                        published_at: content.published_at,
                                        source_id:    source.id,
                                        user_id:      user.id }

        it 'should return false' do
          expect(Synchronizer.new(source).send :already_synchronized?, new_content).to be_falsey
        end

      end

      context 'with different published_at' do

        let(:new_content) { Content.new title:        content.title,
                                        description:  content.description,
                                        url:          content.url,
                                        published_at: content.published_at + 1.day,
                                        source_id:    source.id,
                                        user_id:      user.id }

        it 'should return false' do
          expect(Synchronizer.new(source).send :already_synchronized?, new_content).to be_falsey
        end

      end

      context 'with different source_id' do

        let(:new_content) { Content.new title:        content.title,
                                        description:  content.description,
                                        url:          content.url,
                                        published_at: content.published_at,
                                        source_id:    source.id + 1,
                                        user_id:      user.id }

        it 'should return false' do
          expect(Synchronizer.new(source).send :already_synchronized?, new_content).to be_falsey
        end

      end

    end

    context 'with different user_id' do

      let(:new_content) { Content.new title:        content.title,
                                      description:  content.description,
                                      url:          content.url,
                                      published_at: content.published_at,
                                      source_id:    source.id,
                                      user_id:      user.id + 1 }

      it 'should return false' do
        expect(Synchronizer.new(source).send :already_synchronized?, new_content).to be_falsey
      end

    end

  end

end
