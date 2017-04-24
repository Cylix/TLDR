module ContentsHelper

  # Return active if the current source filter applied matched the source filter of the link
  # Otherwise, return nil
  def content_link_active_class(source_filter, link_source_filter)
    'active' if source_filter == link_source_filter
  end

end
