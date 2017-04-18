class AddDatesForSourcesAndContents < ActiveRecord::Migration[5.0]

  def change
    ###
    # Sources
    ###
    # last_synchronized_at
    # last synchronization date
    # null is authorized and means that the source has never been synchronized
    add_column :sources, :last_synchronized_at, :datetime, default: nil, null: true
    # synchronization_state
    # enum { never_synchronized, in_progress, success, fail(_fail_type) }
    add_column :sources, :synchronization_state, :integer, default: 'never', null: false

    ###
    # Contents
    ###
    # published_at
    # date at which the content was published
    # null is allowed and means that the publication date is unknown
    add_column :contents, :published_at, :datetime, default: nil, null: true
    # synchronized_at
    # date at which the content was imported
    add_column :contents, :synchronized_at, :datetime, default: Time.now, null: false
  end

end
