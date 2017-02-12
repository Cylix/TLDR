class Source::RSS < Source

  # validations
  validates :rss_feed, presence: true
  validate :validates_rss_feed_format

  private

  # validates rss_feed format
  def validates_rss_feed_format
    errors.add(:rss_feed, :invalid) unless URLHelper::valid_url?(rss_feed)
  end

end
