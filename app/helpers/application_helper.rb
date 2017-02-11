module ApplicationHelper

  # returns whether there is some validations errors
  def has_model_error?
    resource&.errors&.full_messages&.any?
  end

  # returns model validations errors
  def model_errors
    resource&.errors&.full_messages
  end

end
