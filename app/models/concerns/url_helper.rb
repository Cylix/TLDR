require 'active_support/concern'

module URLHelper
  extend ActiveSupport::Concern

  # returns whether the given URL is valid or not
  def valid_url?(uri)
    uri = URI.parse(uri) and !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

end
