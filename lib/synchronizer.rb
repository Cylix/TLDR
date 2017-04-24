class Synchronizer

  attr_accessor :source

  # constructor
  def initialize(source)
    @source = source
  end

  def synchronize!
  end

  protected

  def already_synchronized?(content)
    Content.exists? title:          content.title,
                    description:    content.description,
                    url:            content.url,
                    published_at:   content.published_at, # mightor might not be wise: updates? delete/repost?
                    source_id:      content.source.id,
                    user_id:        content.user.id
  end

end
