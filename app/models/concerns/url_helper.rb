require 'active_support/concern'

module URLHelper

  # returns whether the given URL is valid or not
  def self.valid_url?(uri)
    uri = URI.parse(uri) and !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

end
