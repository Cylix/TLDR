FactoryGirl.define do

  factory :rss_source, class: Source::RSS do
    name          'RSS'
    description   'RSS feed'
    url           'https://blog.com/xxx'
    rss_feed      'https://blog.com/xxx/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :build
  end

  factory :rss_source_with_user, class: Source::RSS do
    name          'RSS'
    description   'RSS feed'
    url           'https://blog.com/xxx'
    rss_feed      'https://blog.com/xxx/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :create
  end

  factory :rss_source_edited, class: Source::RSS do
    name          'RSS Edited'
    description   'RSS Edited feed'
    url           'https://blog.com/yyy'
    rss_feed      'https://blog.com/yyy/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :build
  end

  factory :rss_source_edited_with_user, class: Source::RSS do
    name          'RSS Edited'
    description   'RSS Edited feed'
    url           'https://blog.com/yyy'
    rss_feed      'https://blog.com/yyy/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :create
  end

  factory :youtube_source, class: Source::Youtube do
    name          'YT Channel'
    description   'YT Channel feed'
    url           'https://youtube.com/channel/xxx'
    type          'Source::Youtube'

    association :user, factory: :user, strategy: :build
  end

end
