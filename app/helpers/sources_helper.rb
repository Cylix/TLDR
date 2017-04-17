module SourcesHelper

  # Build array for options_for_select
  # [ ['RSS', 'Source::RSS'], ... ]
  def allowed_source_types_for_select
    Source.descendants.collect { |s| [printable_source_type(s.to_s), s.to_s] }
  end

  # return a human-readable string for a given source type
  def printable_source_type(type)
    I18n.t("models.source.#{ type.underscore }")
  end

  # return a font awesome class icon for a given source type
  def iconable_source_type(type)
    "fa-#{ type.underscore.split('/').last }"
  end

end
