FactoryGirl.define do

  factory :rss_source, class: Source::RSS do
    name          'YT Channel'
    description   'YT Channel feed'
    url           'https://youtube.com/channel/xxx'
    rss_feed      'https://youtube.com/channel/xxx/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :build
  end

  factory :rss_source_with_user, class: Source::RSS do
    name          'YT Channel'
    description   'YT Channel feed'
    url           'https://youtube.com/channel/xxx'
    rss_feed      'https://youtube.com/channel/xxx/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :create
  end

  factory :rss_source_edited, class: Source::RSS do
    name          'YT Channel Edited'
    description   'YT Channel Edited feed'
    url           'https://youtube.com/channel/yyy'
    rss_feed      'https://youtube.com/channel/yyy/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :build
  end

  factory :rss_source_edited_with_user, class: Source::RSS do
    name          'YT Channel Edited'
    description   'YT Channel Edited feed'
    url           'https://youtube.com/channel/yyy'
    rss_feed      'https://youtube.com/channel/yyy/rss'
    type          'Source::RSS'

    association :user, factory: :user, strategy: :create
  end

end
