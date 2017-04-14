module ApplicationHelper

  # returns whether there is some validations errors
  def has_model_error?
    resource&.errors&.full_messages&.any?
  end

  # returns model validations errors
  def model_errors
    resource&.errors&.full_messages
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
