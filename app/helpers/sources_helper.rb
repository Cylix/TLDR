module SourcesHelper

  # Build array for options_for_select
  # [ ['RSS', 'Source::RSS'], ... ]
  def allowed_source_types_for_select
    Source.descendants.collect { |s| [printable_source_type(s.to_s), s.to_s] }
  end

  # Return a bootstrap class changing the color of the state text
  def colorized_synchronization_state(state)
    case state.to_sym
    when :never
      'text-muted'
    when :in_progress
      'text-warning'
    when :success
      'text-success'
    when :fail
      'text-danger'
    end
  end

  # return a font awesome class icon for a given source type
  def iconable_source_type(type)
    "fa-#{ type.underscore.split('/').last }"
  end

  # return an icon corresponding to the synchronization state
  def iconable_synchronization_state(state)
    case state.to_sym
    when :never
      'fa-question-circle'
    when :in_progress
      'fa-clock-o'
    when :success
      'fa-check'
    when :fail
      'fa-exclamation-triangle'
    end
  end

  # return a human-readable string for a given source type
  def printable_source_type(type)
    I18n.t("models.source.#{ type.underscore }")
  end

  # return a human-readable string for a given source sync state
  def printable_synchronization_state(state)
    I18n.t("models.source.synchronization_state.#{ state }")
  end

end
