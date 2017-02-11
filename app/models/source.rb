class Source < ApplicationRecord

  # associations
  belongs_to :user

  # validations
  validates :name,        length: { minimum: 2 }, presence: true
  validates :description, length: { minimum: 0, allow_nil: false, message: I18n.t("activerecord.errors.models.source.description.nil") }
  validates :url,         presence: true
  validates :rss_feed,    presence: true
  validate  :validates_urls_format
  # association validations
  validates_associated  :user
  validates_presence_of :user

  private

  # validates url and rss_feed format
  def validates_urls_format
    errors.add(:url, :invalid) unless valid_url?(url)
    errors.add(:rss_feed, :invalid) unless valid_url?(rss_feed)
  end

  # returns whether the given URL is valid or not
  def valid_url?(uri)
    uri = URI.parse(uri) and !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

end
