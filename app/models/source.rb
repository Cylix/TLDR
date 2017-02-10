class Source < ApplicationRecord

  # validations
  validates :name,        length: { minimum: 2 }, presence: true
  validates :description, length: { minimum: 0, allow_nil: false, message: "can't be nil" }
  validates :url,         presence: true
  validates :rss_feed,    presence: true
  validate  :validates_urls_format

  private

  # validates url and rss_feed format
  def validates_urls_format
    errors.add(:url, "has an invalid format") unless valid_url?(url)
    errors.add(:rss_feed, "has an invalid format") unless valid_url?(rss_feed)
  end

  # returns whether the given URL is valid or not
  def valid_url?(uri)
    uri = URI.parse(uri) and !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

end
