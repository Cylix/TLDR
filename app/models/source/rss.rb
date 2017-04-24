class Source::RSS < Source

  # validations
  validates :rss_feed, presence: true
  validate :validates_rss_feed_format

  def synchronizer
    Synchronizer::RSS.new self
  end

  # returns the list of fields specific to this particular type of source
  def self.type_specific_fields
    %w[rss_feed]
  end

  private

  # validates rss_feed format
  def validates_rss_feed_format
    errors.add(:rss_feed, :invalid) unless URLHelper::valid_url?(rss_feed)
  end

end
