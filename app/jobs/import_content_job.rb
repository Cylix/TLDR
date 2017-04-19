class ImportContentJob < ApplicationJob

  queue_as :default

  cattr_accessor(:is_running) { false }

  def perform(*args)
    Rails.logger.info '[ImportContentJob] Job started'

    # Check if lock is already acquired by some task
    if is_running
      Rails.logger.info '[ImportContentJob] Already running, exiting'
      return
    end

    # Lock
    is_running = true
    # Start synchronization
    synchronize_sources
  ensure
    # Unlock
    is_running = false
    Rails.logger.info '[ImportContentJob] Job finished'
  end

  private

  def synchronize_sources
    Source.all.each do |source|
      begin
        Rails.logger.info "[ImportContentJob] Synchronization started for source: #{source}"
        source.update_attribute :synchronization_state, :in_progress
        source.synchronizer.synchronize!
        source.update_attributes synchronization_state: :success, last_synchronized_at: Time.now
        Rails.logger.info "[ImportContentJob] Synchronization finished for source: #{source}"
      rescue Exception => e
        Rails.logger.info "[ImportContentJob] Synchronization failed for source: #{source} (#{e.to_s})"
        source.update_attributes synchronization_state: :fail, last_synchronized_at: Time.now
      end
    end
  end

end
