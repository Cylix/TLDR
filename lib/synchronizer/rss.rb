require 'rss'
require 'open-uri'

class Synchronizer::RSS < Synchronizer

  def synchronize!
    # Fetch RSS feed
    open(@source.rss_feed) do |rss|
      # Parse RSS feed
      feed = ::RSS::Parser.parse(rss)

      # iterate over the elements
      feed.items.each do |item|
        content = Content.new title:            item.title,
                              description:      item.description,
                              url:              item.link,
                              published_at:     item.date,
                              synchronized_at:  Time.now,
                              source:           @source,
                              user:             @source.user

        if already_synchronized? content
          puts "[Import][Skip] content: #{content.title} already_synchronized"
        elsif content.save
          puts "[Import][Success] content_id: #{content.id} source_id: #{@source.id} user_id: #{@source.user.id}"
        else
          puts "[Import][Fail] content: #{content.title} error:#{content.errors.full_messages}"
        end
      end
    end
  end

end
