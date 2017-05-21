require 'rails_helper'

RSpec.feature "ImportContentJob", type: :feature do

  let!(:user) { create(:user) }
  let!(:source) { create(:rss_source, user: user) }

  let!(:synchronizer) { Synchronizer::RSS.new source }
  let!(:import_job) { ImportContentJob.new }

  before(:each) do
    allow(Source).to receive(:all).and_return([source])
    allow(source).to receive(:synchronizer).and_return(synchronizer)
  end

  describe 'already running' do

    before do
      allow(import_job).to receive(:synchronize_sources)
      allow(import_job).to receive(:is_running) { true }
    end

    it 'should not synchronize' do
      expect(import_job).not_to receive(:synchronize_sources)
      expect(synchronizer).not_to receive(:synchronize!)
      import_job.perform
    end

  end

  describe 'not already running' do

    describe 'with import failure' do

      before (:each) do
        allow(import_job).to receive(:is_running) { false }
        allow(synchronizer).to receive(:synchronize!) { raise "fail" }
      end

      it 'should synchronize' do
        expect(import_job).to receive(:synchronize_sources).once.and_call_original
        expect(synchronizer).to receive(:synchronize!).once
        import_job.perform
      end

      it 'should update source with the right status' do
        expect { import_job.perform }.to change { source.synchronization_state }.from("never").to("fail")
      end

      it 'should update synchronize_at' do
        expect { import_job.perform }.to change { source.last_synchronized_at }
      end

    end

    describe 'with successful import' do

      before (:each) do
        allow(import_job).to receive(:is_running) { false }
        allow(synchronizer).to receive(:synchronize!)
      end

      it 'should synchronize' do
        expect(import_job).to receive(:synchronize_sources).once.and_call_original
        expect(synchronizer).to receive(:synchronize!).once
        import_job.perform
      end

      it 'should update source with the right status' do
        expect { import_job.perform }.to change { source.synchronization_state }.from("never").to("success")
      end

      it 'should update synchronize_at' do
        expect { import_job.perform }.to change { source.last_synchronized_at }
      end

    end

  end

end
