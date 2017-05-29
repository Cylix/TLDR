module ContentsHelper

  def class_for_content_card(content)
    content_card_class = %w[content]

    content_card_class << 'pinned'  if content.is_pinned?
    content_card_class << 'snoozed' if content.is_snoozed?
    content_card_class << 'done'    if content.is_done?
    content_card_class << 'trashed' if content.is_trashed?

    content_card_class.join ' '
  end

end
