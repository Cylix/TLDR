module ApplicationHelper

  # returns whether there is some validations errors
  def has_model_error?
    resource&.errors&.full_messages&.any?
  end

  # returns model validations errors
  def model_errors
    resource&.errors&.full_messages
  end

  # Return active if the current page has the expected type and extra
  # Otherwise, return nil
  def navbar_active_link(page_info, expected_page_type, expected_extra = nil)
    page_info = JSON.parse(page_info)
    'active' if page_info[:page_type] == expected_page_type && page_info[:extra] == expected_extra
  rescue
    nil
  end

  # trunk text to first n words
  def trunk_words(str, nb_words)
    words = str.split(" ")

    if words.length <= nb_words
      str
    else
      words.first(nb_words).join(" ") + "..."
    end
  end

end
